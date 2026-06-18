# =====================================================================
# modelsim.tcl - ModelSim simulation script (library mode)
# =====================================================================
# Non-project (library-mode) flow: compiles sources directly into the
# project's simdir, then elaborates and simulates the testbench.
#
# Usage:  run from the project root:
#   scripts\sim.bat
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
set SIMDIR      "sim"

foreach line [read_sources [file join $PROJ_DIR sources.f]] {
    set kw [lindex $line 0]
    set val [lindex $line 1]
    switch -- $kw {
        design  { lappend DESIGN_FILES $val }
        sim     { lappend SIM_FILES    $val }
        top     { set TOP       $val }
        simdir  { set SIMDIR    $val }
        default { }
    }
}

set SOURCES {}
foreach f [concat $DESIGN_FILES $SIM_FILES] {
    lappend SOURCES [file join $PROJ_DIR $f]
}

# ---- Work in the simulation output directory -------------------------
catch {project close}
set SIM_DIR [file normalize [file join $PROJ_DIR $SIMDIR]]
file mkdir $SIM_DIR
cd $SIM_DIR
puts "INFO: working directory = [pwd]"

# ---- Fresh work library ---------------------------------------------
set WORK_LIB work
if {[file exists $WORK_LIB]} {
    vdel -lib $WORK_LIB -all
}
vlib $WORK_LIB

# ---- Compile every source -------------------------------------------
proc compile_file {f} {
    switch -- [file extension $f] {
        .sv     { vlog -sv $f }
        .v      { vlog $f }
        .vhd    { vcom $f }
        .vhdl   { vcom $f }
        default { error "Unknown file extension on $f" }
    }
}
foreach f $SOURCES {
    puts "INFO: compiling [file tail $f]"
    compile_file $f
}

# ---- Elaborate + simulate -------------------------------------------
vsim -voptargs=+acc -onfinish stop $WORK_LIB.$TOP

if {[info exists GUI] && $GUI} {
    add wave -r /*
}

run -all

puts "INFO: ModelSim simulation finished."

if {[batch_mode]} {
    quit -f
}
