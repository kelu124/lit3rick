if {[catch {

# define run engine funtion
source [file join {/opt/lscc/radiant/2.0} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "/home/andrew/projects/unoric_board/fft_adc_new/radiant/fft_adc"
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- fft_adc_impl_1_cpe.ldc
run_engine_newmsg cpe -f "fft_adc_impl_1.cprj" "pll_adc.cprj" "sc_fifo.cprj" "ebr_dp.cprj" -a "iCE40UP" -o fft_adc_impl_1_cpe.ldc
# synthesize top design
file delete -force -- fft_adc_impl_1.vm fft_adc_impl_1.ldc
run_engine_newmsg synthesis -f "fft_adc_impl_1_lattice.synproj"
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o fft_adc_impl_1_syn.udb fft_adc_impl_1.vm] "/home/andrew/projects/unoric_board/fft_adc_new/radiant/fft_adc/impl_1/fft_adc_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
