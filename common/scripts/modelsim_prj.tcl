# =====================================================================
# modelsim_prj.tcl - ModelSim simulation script (project mode)
# =====================================================================
# Creates a ModelSim project (.mpf) in the project's simdir/prj/,
# adds the sources, compiles via 'project compileall', and runs.
#
# Usage:  run from the project root:
#   scripts\sim_prj.bat
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
set TOP         ""
set PROJ_NAME   ""
set SIMDIR      "sim"

foreach line [read_sources [file join $PROJ_DIR sources.f]] {
    set kw [lindex $line 0]
    set val [lindex $line 1]
    switch -- $kw {
        design  { lappend DESIGN_FILES $val }
        sim     { lappend SIM_FILES    $val }
        top     { set TOP       $val }
        name    { set PROJ_NAME $val }
        simdir  { set SIMDIR    $val }
        default { }
    }
}

# ---- Command-line / env override for top testbench ------------------
# sim.bat/synth.bat pass SIM_TOP_OVERRIDE to run a different testbench
# without editing sources.f.  Project mode handles a single top only.
if {[info exists ::env(SIM_TOP_OVERRIDE)] && $::env(SIM_TOP_OVERRIDE) ne ""} {
    if {$::env(SIM_TOP_OVERRIDE) eq "all"} {
        error "project mode (prj) supports a single testbench only, not 'all'"
    }
    set TOP $::env(SIM_TOP_OVERRIDE)
    puts "INFO: top overridden via SIM_TOP_OVERRIDE = $TOP"
}

# Normalize all source paths (ModelSim vlog can't handle '..' in paths)
set SOURCES [concat $DESIGN_FILES $SIM_FILES]
set SOURCES_NORM {}
foreach f $SOURCES { lappend SOURCES_NORM [file normalize [file join $PROJ_DIR $f]] }
set SOURCES $SOURCES_NORM

# ---- Work in the project output directory ----------------------------
catch {project close}
set PROJ_DIR_OUT [file normalize [file join $PROJ_DIR $SIMDIR prj]]
file mkdir $PROJ_DIR_OUT
cd $PROJ_DIR_OUT
puts "INFO: project directory = [pwd]"

if {![file exists modelsim.ini]} { catch {vmap -c} }

# ---- (Re)create the project -----------------------------------------
if {[file exists $PROJ_NAME.mpf]} { file delete -force $PROJ_NAME.mpf }
project new . $PROJ_NAME

if {![file exists work]} { vlib work }
vmap work work

# ---- Add sources with correct language type --------------------------
proc file_language {f} {
    switch -- [file extension $f] {
        .sv     { return SystemVerilog }
        .v      { return Verilog }
        .vhd    { return VHDL }
        .vhdl   { return VHDL }
        default { error "Unknown file extension on $f" }
    }
}
foreach f $SOURCES {
    project addfile [file join $PROJ_DIR $f] [file_language $f]
}

# ---- Compile the whole project --------------------------------------
puts "INFO: compiling project ..."
project compileall

# ---- Elaborate + simulate -------------------------------------------
vsim -voptargs=+acc -onfinish stop work.$TOP

if {[info exists GUI] && $GUI} {
    add wave -r /*
}

run -all

puts "INFO: ModelSim project-mode simulation finished."

if {[batch_mode]} {
    quit -f
}
