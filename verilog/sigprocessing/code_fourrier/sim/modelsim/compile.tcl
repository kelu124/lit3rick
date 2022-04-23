# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.

set library_file_list [list          \
  work [list \
             ../../rtl/ip/lscc_mult_accumulate.v      \
             ../../rtl/ip/lscc_complex_mult.v      \
             ../../rtl/ip/lscc_fifo.v      \
             ../../rtl/ip/lscc_adder.v      \
             ../../rtl/ip/lscc_add_sub.v      \
             ../../rtl/ip/lscc_multiplier.v      \
             ../../rtl/ip/lscc_subtractor.v      \
             ../../rtl/ip/SB_RAM40_4K.v      \
             ../../rtl/ip/EBR_B.v      \
             ../../rtl/ip/PDP4K.v      \
             ../../rtl/ip/RAM40_4K.v      \
             ../../rtl/ip/RAM4K.v      \
             ../../rtl/ip/read_data_decoder.v      \
             ../../rtl/ip/write_data_decoder.v      \
             ../../rtl/ip/mask_decoder.v      \
             ../../rtl/dft_dline.v      \
             ../../rtl/dft_mul.v      \
             ../../rtl/dft_add.v      \
             ../../rtl/dft_sub.v      \
             ../../rtl/dft_addsub.v      \
             ../../rtl/dft_twiddle_rom.v      \
             ../../rtl/dft_complex_mul.v      \
             ../../rtl/dft_sqrt.v      \
             ../../rtl/dft_sqrsum.v      \
             ../../rtl/dft_complex_abs.v      \
             ../../rtl/dft_preproc.v          \
             ../../rtl/dft_postproc.v          \
             ../../rtl/dft_fifo.v             \
             ../../rtl/dft_core.v             \
             ../../rtl/dft_freq_ram.v         \
             ../../rtl/dft.v                  \
             ../tb/$tb_name.v]              \
]
set top_level              work.$tb_name

# After sourcing the script from ModelSim for the
# first time use these commands to recompile.
proc r  {} {
  write format wave -window .main_pane.wave.interior.cs.body.pw.wf wave.do
  uplevel #0 source compile.tcl
}
proc rr {} {global last_compile_time
            set last_compile_time 0
            r                            }
proc q  {} {quit -force                  }

#Does this installation support Tk?
set tk_ok 1
if [catch {package require Tk}] {set tk_ok 0}

# Prefer a fixed point font for the transcript
set PrefMain(font) {Courier 10 roman normal}

# Compile out of date files
set time_now [clock seconds]
if [catch {set last_compile_time}] {
  set last_compile_time 0
}
foreach {library file_list} $library_file_list {
  vlib $library
  vmap work $library
  foreach file $file_list {
    if { $last_compile_time < [file mtime $file] } {
      if [regexp {.vhdl?$} $file] {
        vcom -93 $file
      } else {
        vlog -timescale "1 ns / 1 ps" $file
      }
      set last_compile_time 0
    }
  }
}
set last_compile_time $time_now

# Load the simulation
eval vsim $top_level

# If waves exists
if [file exist wave.do] {
  source wave.do
}
