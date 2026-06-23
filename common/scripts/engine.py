#!/usr/bin/env python3
# =====================================================================
# engine.py — cross-platform sim / synth dispatcher
# =====================================================================
# Cross-platform replacement for the old engine.bat + per-project
# sim.bat / synth.bat wrappers.  Works on Windows, Linux, and macOS.
#
# Usage (from any project directory):
#
#   python <path-to>/engine.py sim   <proj_dir> <target> [options]
#   python <path-to>/engine.py synth <proj_dir> <target> [options]
#
#   proj_dir   — path to the project root (sv/, vhdl/) or any parent
#   target     — testbench/top module name, or "all"
#
# Options (order-independent):
#   -b, --backend  modelsim | vivado | xsim   (sim default: modelsim,
#                                               synth default: vivado)
#   -g, --gui      launch tool GUI (single target only)
#   -p, --prj      ModelSim project-mode GUI (implies --gui)
#
# Examples:
#   python ../../common/scripts/engine.py sim . top_tb
#   python ../../common/scripts/engine.py sim . top_tb -g
#   python ../../common/scripts/engine.py sim . top_tb -p
#   python ../../common/scripts/engine.py sim . all
#   python ../../common/scripts/engine.py sim . top_tb -b xsim
#   python ../../common/scripts/engine.py synth . top
#   python ../../common/scripts/engine.py synth . top -g
#   python ../../common/scripts/engine.py synth . all
# =====================================================================

import argparse
import os
import subprocess
import sys
from pathlib import Path
from argparse import RawDescriptionHelpFormatter


# -------------------------------------------------------------------
# Helpers
# -------------------------------------------------------------------

def resolve_proj_dir(arg: str) -> Path:
    """Return the project root directory containing sources.f.

    Accepts any of:
      - the project root itself (sv/, vhdl/)
      - any parent directory — walks up until sources.f is found
    """
    p = Path(arg).resolve()
    if (p / "sources.f").exists():
        return p
    for parent in p.parents:
        if (parent / "sources.f").exists():
            return parent
    sys.exit(f"error: no sources.f found under {p}")


# -------------------------------------------------------------------
# Argument parsing
# -------------------------------------------------------------------

class EngineParser(argparse.ArgumentParser):
    """Custom parser that shows examples on error."""

    def error(self, message):
        """Print error, usage, and examples, then exit."""
        self.print_usage(sys.stderr)
        args = {"prog": self.prog}
        self.exit(
            2,
            f"{self.prog}: error: {message}\n"
            f"\n"
            f"Examples:\n"
            f"  {self.prog} sim  . top_tb     # single testbench\n"
            f"  {self.prog} sim  . all        # all testbenches\n"
            f"  {self.prog} synth . top       # single top\n"
            f"  {self.prog} synth . all       # all tops\n"
        )


def parse_args(argv=None):
    p = EngineParser(
        formatter_class=RawDescriptionHelpFormatter,
        description="Simulate or synthesize FPGA designs "
                    "(cross-platform Python dispatcher).",
        epilog="Use 'all' as the target to run all testbenches or synthesize all tops.",
    )
    p.add_argument(
        "verb",
        choices=["sim", "synth"],
        help="Action: 'sim' to simulate, 'synth' to synthesize",
    )
    p.add_argument(
        "proj_dir",
        help="Path to the project root (sv/, vhdl/) or any parent",
    )
    p.add_argument(
        "target",
        help="Testbench / top module name, or 'all' for all targets",
    )
    p.add_argument(
        "-b", "--backend",
        choices=["modelsim", "xsim", "vivado"],
        help="EDA tool backend "
             "(default: modelsim for sim, vivado for synth)",
    )
    p.add_argument(
        "-g", "--gui",
        action="store_true",
        help="Launch the tool GUI (requires a single target)",
    )
    p.add_argument(
        "-p", "--prj",
        action="store_true",
        help="ModelSim project mode (implies --gui; ModelSim only)",
    )
    return p.parse_args(argv)


# -------------------------------------------------------------------
# Validation
# -------------------------------------------------------------------

def validate(args):
    """Apply the same validation rules as the old engine.bat."""
    if args.verb == "synth" and args.backend == "modelsim":
        sys.exit("error: 'synth' requires Vivado (ModelSim cannot synthesize)")
    if args.prj:
        if args.verb != "sim":
            sys.exit("error: 'prj' is a simulation mode, not valid for synth")
        if args.backend != "modelsim":
            sys.exit("error: 'prj' is ModelSim-only")
        args.gui = True
    if args.target == "all" and args.gui:
        sys.exit("error: 'gui'/'prj' require a single target, not 'all'")


def check_files(args, proj_dir: Path):
    """Verify that the target source file exists (single targets only)."""
    if args.target == "all":
        return
    chkdir = proj_dir / ("tb" if args.verb == "sim" else "rtl")
    name = args.target
    # For synth, strip trailing _tb to match the design module name
    if args.verb == "synth" and name.endswith("_tb"):
        name = name[:-3]
    for ext in (".sv", ".vhd", ".vhdl"):
        if (chkdir / f"{name}{ext}").exists():
            return
    sys.exit(
        f"error: {args.verb} target '{args.target}' not found in "
        f"{chkdir.name}/ (looked for {name}.sv / .vhd / .vhdl)"
    )


# -------------------------------------------------------------------
# Launch
# -------------------------------------------------------------------

def launch(args, proj_dir: Path):
    """Invoke the EDA tool via the appropriate Tcl script.

    Environment variables consumed by the Tcl scripts:
      PROJ_DIR           — project root directory (for sources.f resolution)
      SIM_TOP_OVERRIDE   — ModelSim: overrides the testbench top
      VIV_TOP_OVERRIDE   — Vivado:   overrides the simulation top
    """
    # Resolve the common/scripts/ directory where the Tcl scripts live
    engine_dir = Path(__file__).resolve().parent

    env = os.environ.copy()
    # Add a trailing separator so Tcl's file normalize behaves identically
    # to the old %~dp0 value.
    env["PROJ_DIR"] = str(proj_dir) + os.sep

    if args.backend == "modelsim":
        env["SIM_TOP_OVERRIDE"] = args.target
        tcl_name = "modelsim_prj.tcl" if args.prj else "modelsim.tcl"
        tcl_path = engine_dir / tcl_name
        if args.gui:
            cmd = ["vsim", "-gui", "-do", f"set GUI 1; do {{{tcl_path}}}"]
        else:
            cmd = ["vsim", "-c", "-do", str(tcl_path)]
        try:
            subprocess.run(cmd, check=True, env=env)
        except FileNotFoundError:
            sys.exit(
                "error: 'vsim' not found. Make sure ModelSim/Questa is on your\n"
                "       PATH (e.g. run c:\\cmdtools\\m20.bat or q25.bat first)."
            )

    else:  # vivado / xsim
        env["VIV_TOP_OVERRIDE"] = args.target
        viv_dir = (proj_dir / "viv").resolve()
        viv_dir.mkdir(parents=True, exist_ok=True)
        tcl_path = engine_dir / "vivado.tcl"
        mode_flag = "-sim" if args.verb == "sim" else "-synth"
        all_flag = "-all" if args.target == "all" else ""
        if args.gui:
            base = ["vivado", "-source", str(tcl_path),
                    "-tclargs", mode_flag]
            if all_flag:
                base.append(all_flag)
            base.append("-gui")
            cmd = base
        else:
            base = ["vivado", "-mode", "batch", "-source", str(tcl_path),
                    "-tclargs", mode_flag]
            if all_flag:
                base.append(all_flag)
            cmd = base
        try:
            # Use shell=True because vivado is a .bat file on Windows;
            # CreateProcess can't resolve .bat without the shell.
            subprocess.run(subprocess.list2cmdline(cmd), check=True,
                           env=env, cwd=str(viv_dir), shell=True)
        except FileNotFoundError:
            sys.exit(
                "error: 'vivado' not found. Make sure Vivado is on your PATH\n"
                "       (e.g. run c:\\cmdtools\\v23.bat or v25.bat first)."
            )


# -------------------------------------------------------------------
# Entry point
# -------------------------------------------------------------------

def main():
    args = parse_args()
    if args.backend is None:
        args.backend = "modelsim" if args.verb == "sim" else "vivado"
    proj_dir = resolve_proj_dir(args.proj_dir)
    validate(args)
    check_files(args, proj_dir)
    print(f"INFO: {args.verb} target={args.target} "
          f"backend={args.backend} gui={args.gui}")
    launch(args, proj_dir)


if __name__ == "__main__":
    main()
