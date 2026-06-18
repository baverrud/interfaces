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

set DESIGN_SOURCES {}
foreach f $DESIGN_FILES { lappend DESIGN_SOURCES [file join $PROJ_DIR $f] }
set SIM_SOURCES {}
foreach f $SIM_FILES    { lappend SIM_SOURCES    [file join $PROJ_DIR $f] }

# ---- Create Vivado project ------------------------------------------
set PROJ_DIR_OUT [file normalize [file join $PROJ_DIR $VIVDIR $PROJ_NAME]]
file mkdir $PROJ_DIR_OUT
create_project -force $PROJ_NAME $PROJ_DIR_OUT -part $PART

# ---- Add and configure design sources -------------------------------
proc vivado_file_type {f} {
    switch -- [file extension $f] {
        .sv     { return SystemVerilog }
        .v      { return Verilog }
        .vhd    { return VHDL }
        .vhdl   { return VHDL }
        default { error "Unknown file extension on $f" }
    }
}

add_files -fileset sources_1 $DESIGN_SOURCES
foreach f $DESIGN_SOURCES {
    set_property file_type [vivado_file_type $f] [get_files [file tail $f]]
}
set_property top $TOP_SYNTH [get_filesets sources_1]

# ---- Add and configure simulation testbench -------------------------
add_files -fileset sim_1 $SIM_SOURCES
foreach f $SIM_SOURCES {
    set_property file_type [vivado_file_type $f] [get_files [file tail $f]]
}
set_property top $TOP_SIM [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "INFO: Project '$PROJ_NAME' created at $PROJ_DIR_OUT"
puts "INFO: Synthesis top = $TOP_SYNTH"
puts "INFO: Simulation top = $TOP_SIM"

# ---- Optionally run the flows ---------------------------------------
# Pass -run on the command line:  vivado -mode batch ... -tclargs -run
set RUN_FLOWS 0
if {[lsearch -exact $argv "-run"] >= 0} {
    set RUN_FLOWS 1
}

if {$RUN_FLOWS} {
    puts "INFO: ---- Running RTL elaboration / synthesis ----"
    synth_design -rtl -name rtl_${PROJ_NAME}
    puts "SYNTH: top ports = [llength [get_ports]]"

    puts "INFO: ---- Running behavioral simulation ----"
    launch_simulation
    puts "INFO: Simulation finished."
    close_sim -force
    close_project -quiet
    puts "INFO: Done."
}
