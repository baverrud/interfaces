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

# ---- Command-line / env override for top testbench ------------------
# sim.bat can pass SIM_TOP_OVERRIDE to run a different testbench without
# editing sources.f.  If set, it replaces the TOP read from sources.f.
if {[info exists ::env(SIM_TOP_OVERRIDE)] && $::env(SIM_TOP_OVERRIDE) ne ""} {
    set TOP $::env(SIM_TOP_OVERRIDE)
    puts "INFO: top overridden via SIM_TOP_OVERRIDE = $TOP"
}

set SOURCES {}
foreach f [concat $DESIGN_FILES $SIM_FILES] {
    lappend SOURCES [file normalize [file join $PROJ_DIR $f]]
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

# ---- Build list of simulation tops (for 'all') ----------------------
# Each testbench top is the basename of its source file.
set SIM_TOPS {}
foreach f $SIM_FILES { lappend SIM_TOPS [file rootname [file tail $f]] }

set GUI_ON [expr {[info exists GUI] && $GUI}]

proc run_one {lib top gui} {
    puts "INFO: ===== simulating $top ====="
    vsim -voptargs=+acc -onfinish stop $lib.$top
    if {$gui} { add wave -r /* }
    run -all
}

# ---- Elaborate + simulate -------------------------------------------
if {$TOP eq "all"} {
    puts "INFO: ---- simulating ALL testbenches ----"
    foreach t $SIM_TOPS { run_one $WORK_LIB $t $GUI_ON }
} else {
    run_one $WORK_LIB $TOP $GUI_ON
}

puts "INFO: ModelSim simulation finished."

if {[batch_mode]} {
    quit -f
}
