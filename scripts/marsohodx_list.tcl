proc marsohodx_list { src listfile } {

    # Read the listfile which contains a list of HDL sources.
    set fp [open "$listfile" r]
    set file_data [read $fp]
    close $fp

    # Add each source file to the project
    set data [split $file_data "\n"]
    foreach line $data {
        set trimmed [string trim $line]
        if { [string length $trimmed] > 0 } {
            set firstchar [string index $trimmed 0]
            if { $firstchar != "#" } {
                set ext [string tolower [file extension $trimmed]]
                if { $ext == ".v" } {
                    set_global_assignment -name VERILOG_FILE "$src/$trimmed"
                } elseif { $ext == ".vhdl" } {
                    set_global_assignment -name VHDL_FILE "$src/$trimmed"
                } elseif { $ext == ".qip" } {
                    set_global_assignment -name QIP_FILE "$src/$trimmed"
                } elseif { $ext == ".sip" } {
                    set_global_assignment -name SIP_FILE "$src/$trimmed"
                } elseif { $ext == ".mif" } {
                    set_global_assignment -name MIF_FILE "$src/$trimmed"
                } elseif { $ext == ".sdc" } {
                    set_global_assignment -name SDC_FILE "$src/$trimmed"
                } else {
                    puts "Error: Unknown or unhandled file type \"$ext\"."
                }
                set_global_assignment -name SEARCH_PATH "[file dirname "$src/$trimmed"]/"
            }
        }
    }
}
