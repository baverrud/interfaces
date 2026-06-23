# =====================================================================
# vivado.tcl - Vivado project script
# =====================================================================
# Creates a Vivado project under the project's vivdir/, adds sources,
# and optionally runs synthesis + simulation.
#
# Usage:  run from the project root:
#   scripts\viv.bat            (batch: synth + sim, then exit)
#   scripts\viv_gui.bat        (GUI: create project, leave open)
# =====================================================================

# ---- Locate project root --------------------------------------------
if {[info exists ::env(PROJ_DIR)]} {
    set PROJ_DIR [file normalize $::env(PROJ_DIR)]
} else {
    set PROJ_DIR [file normalize [file dirname [info script]]]
}

# ---- Read sources.f (file list + config) ----------------------------
proc read_sources {path} {
    set result {}
    set fp [open $path r]
    foreach line [split [read $fp] "\n"] {
        set line [string trim $line]
        if {$line eq "" || [string match "#*" $line]} { continue }
        lappend result $line
    }
    close $fp
    return $result
}

set DESIGN_FILES {}
set SIM_FILES   {}
set TOP_SYNTH   ""
set TOP_SIM     ""
set PROJ_NAME   ""
set PART        ""
set VIVDIR      "viv"

foreach line [read_sources [file join $PROJ_DIR sources.f]] {
    set kw [lindex $line 0]
    set val [lindex $line 1]
    switch -- $kw {
        design  { lappend DESIGN_FILES $val }
        sim     { lappend SIM_FILES    $val }
        top     { set TOP_SIM   $val }
        name    { set PROJ_NAME $val }
        part    { set PART      $val }
        vivdir  { set VIVDIR    $val }
        default { }
    }
}
# Synthesis top is the design module (same as name, without "tb_" prefix)
set TOP_SYNTH $PROJ_NAME

# ---- Run mode from argv ---------------------------------------------
#   -synth  synthesize only            -sim   simulate only
#   -run    legacy: RTL elab + sim     -all   iterate all tops/testbenches
#   -gui    keep project/sim open (do not close at end)
set MODE_SYNTH [expr {[lsearch -exact $argv "-synth"] >= 0}]
set MODE_SIM   [expr {[lsearch -exact $argv "-sim"]   >= 0}]
set MODE_RUN   [expr {[lsearch -exact $argv "-run"]   >= 0}]
set MODE_ALL   [expr {[lsearch -exact $argv "-all"]   >= 0}]
set MODE_GUI   [expr {[lsearch -exact $argv "-gui"]   >= 0}]

# ---- Command-line / env override for top module ----------------------
# sim.bat/synth.bat pass VIV_TOP_OVERRIDE to target a specific top
# without editing sources.f.  Ignored when -all is given.
if {!$MODE_ALL && [info exists ::env(VIV_TOP_OVERRIDE)] && \
        $::env(VIV_TOP_OVERRIDE) ne "" && $::env(VIV_TOP_OVERRIDE) ne "all"} {
    set TOP_SIM $::env(VIV_TOP_OVERRIDE)
    puts "INFO: top overridden via VIV_TOP_OVERRIDE = $TOP_SIM"
}

# ---- Build the list of simulation tops ------------------------------
# A simulation top is a testbench (basename of a 'sim' file).  The
# matching synthesis top is the same name with a trailing "_tb" removed.
set SIM_TOPS {}
foreach f $SIM_FILES { lappend SIM_TOPS [file rootname [file tail $f]] }

set TARGETS {}
if {$MODE_ALL} {
    if {$MODE_SIM} {
        set TARGETS $SIM_TOPS
    } else {
        foreach t $SIM_TOPS {
            set st [regsub {_tb$} $t ""]
            if {[lsearch -exact $TARGETS $st] < 0} { lappend TARGETS $st }
        }
    }
} else {
    lappend TARGETS $TOP_SIM
}

set DESIGN_SOURCES {}
foreach f $DESIGN_FILES { lappend DESIGN_SOURCES [file normalize [file join $PROJ_DIR $f]] }
set SIM_SOURCES {}
foreach f $SIM_FILES    { lappend SIM_SOURCES    [file normalize [file join $PROJ_DIR $f]] }

# ---- File-type helper -----------------------------------------------
proc vivado_file_type {f} {
    switch -- [file extension $f] {
        .sv     { return SystemVerilog }
        .v      { return Verilog }
        .vhd    { return {VHDL 2019} }
        .vhdl   { return {VHDL 2019} }
        default { error "Unknown file extension on $f" }
    }
}

# ---- Create + configure a project for one (synth, sim) top pair ------
proc build_project {proj_name top_synth top_sim} {
    global DESIGN_SOURCES SIM_SOURCES PROJ_DIR VIVDIR PART
    set out [file normalize [file join $PROJ_DIR $VIVDIR $proj_name]]
    file mkdir $out
    create_project -force $proj_name $out -part $PART

    add_files -fileset sources_1 $DESIGN_SOURCES
    foreach f $DESIGN_SOURCES {
        set_property file_type [vivado_file_type $f] [get_files [file tail $f]]
    }
    set_property top $top_synth [get_filesets sources_1]

    add_files -fileset sim_1 $SIM_SOURCES
    foreach f $SIM_SOURCES {
        set_property file_type [vivado_file_type $f] [get_files [file tail $f]]
    }
    set_property top $top_sim [get_filesets sim_1]
    set_property top_lib xil_defaultlib [get_filesets sim_1]

    update_compile_order -fileset sources_1
    update_compile_order -fileset sim_1
    puts "INFO: project '$proj_name' created (synth=$top_synth sim=$top_sim)"
}

# ---- Process every target -------------------------------------------
set FAIL 0
foreach tgt $TARGETS {
    set top_sim   $tgt
    set top_synth [regsub {_tb$} $tgt ""]
    set proj_name $top_synth
    puts "INFO: ===== target $tgt (synth=$top_synth) ====="
    build_project $proj_name $top_synth $top_sim

    # -- synthesis (skipped in GUI mode: leave project open for the user)
    if {($MODE_SYNTH || $MODE_RUN) && !$MODE_GUI} {
        puts "INFO: ---- synthesis: $top_synth ----"
        if {[catch { synth_design -top $top_synth } emsg]} {
            puts "ERROR: synthesis failed for $top_synth: $emsg"
            set FAIL 1
        } else {
            puts "SYNTH: $top_synth OK ([llength [get_ports]] ports)"
        }
    }

    # -- behavioral simulation
    if {$MODE_SIM || $MODE_RUN} {
        puts "INFO: ---- simulation: $top_sim ----"
        if {[catch { launch_simulation } emsg]} {
            puts "ERROR: simulation failed for $top_sim: $emsg"
            set FAIL 1
        }
        if {!$MODE_GUI} { catch {close_sim -force} }
    }

    if {!$MODE_GUI} { close_project -quiet }
}

if {!$MODE_GUI} {
    if {$FAIL} { puts "RESULT: FAIL" } else { puts "RESULT: PASS" }
    puts "INFO: Done."
}
