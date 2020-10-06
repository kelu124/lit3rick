#14
#Total failed paths = 353 with start point 23
#Total failed paths = 325 with start point 33
#Total failed paths = 311 with start point 85
#Total failed paths = 311 with start point 85
#Total failed paths = 50 with start point 22

set best_result 10000
set best_str ""
set all_runs {}
for {set i 1} {${i} <= 100} {incr i} {
    set current_start_point ${i}
    prj_clean_impl -impl impl_1
    prj_set_strategy_value -strategy timing_cust par_place_iterator_start_pt=${i}
    catch {
        prj_run PAR -impl impl_1
    } err
    

    set path [prj_get_impl_path]
    set fp [open "${path}/fft_adc_impl_1_summary.html"]
    set file_data [read ${fp}]
    close ${fp}

    set file_data [split ${file_data} \n]
    # <TD class='td_2_2' rowspan=1 colspan=1><font COLOR=red>Place & Route, 453 (setup), 0 (hold)</font></TD>
    set re "<TD class='td_2_2' rowspan=1 colspan=1><font COLOR=red>Place & Route"

    foreach line ${file_data} {
        if { [regexp ${re} ${line}] } {
            scan ${line} "${re}, %d" total_fail_paths
        }
    }

    set result "Total failed paths = ${total_fail_paths} with start point ${current_start_point}"
    lappend all_runs ${result}
    if { ${total_fail_paths} < ${best_result} } {
        set best_result ${total_fail_paths}
        set best_str ${result}
    }
    puts "\n${result}"
}

puts [join ${all_runs} \n]
puts "The best result: ${best_str}"