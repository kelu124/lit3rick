# Simply change the project settings in this section
# for each new project. There should be no need to
# modify the rest of the script.

set library_file_list [list \
  work [list \
             ../src/rtl/fft/ip/lscc_mult_accumulate.v    \
             ../src/rtl/fft/ip/lscc_complex_mult.v       \
             ../src/rtl/fft/ip/lscc_fifo.v               \
             ../src/rtl/fft/ip/lscc_adder.v              \
             ../src/rtl/fft/ip/lscc_add_sub.v            \
             ../src/rtl/fft/ip/lscc_multiplier.v         \
             ../src/rtl/fft/ip/lscc_subtractor.v         \
             ../src/rtl/fft/ip/EBR_B.v                   \
             ../src/rtl/fft/ip/PDP4K.v                   \
             ../src/rtl/fft/ip/RAM40_4K.v                \
             ../src/rtl/fft/ip/RAM4K.v                   \
             ../src/rtl/fft/ip/read_data_decoder.v       \
             ../src/rtl/fft/ip/write_data_decoder.v      \
             ../src/rtl/fft/ip/mask_decoder.v            \
             ../src/rtl/fft/ip/lscc_rom.v                \
             ../src/rtl/fft/dft_dline.v                  \
             ../src/rtl/fft/dft_mul.v                    \
             ../src/rtl/fft/dft_add.v                    \
             ../src/rtl/fft/dft_sub.v                    \
             ../src/rtl/fft/dft_addsub.v                 \
             ../src/rtl/fft/dft_twiddle_rom.v            \
             ../src/rtl/fft/dft_complex_mul.v            \
             ../src/rtl/fft/dft_sqrt.v                   \
             ../src/rtl/fft/dft_sqrsum.v                 \
             ../src/rtl/fft/dft_complex_abs.v            \
             ../src/rtl/fft/dft_preproc.v                \
             ../src/rtl/fft/dft_postproc.v               \
             ../src/rtl/fft/dft_fifo.v                   \
             ../src/rtl/fft/dft_core.v                   \
             ../src/rtl/fft/dft_freq_ram.v               \
             ../src/rtl/fft/dft.v                        \
             ../src/rtl/ip_cores/sc_fifo.v               \
             ../src/rtl/ip_cores/ebr_dp.v                \
             ../src/rtl/debounce.v                       \
             ../src/rtl/signal_filter.v                  \
             ../src/rtl/i2c_slave_axil_master.v          \
             ../src/rtl/i2c_slave.v                      \
             ../src/rtl/i2s_control.v                    \
             ../src/rtl/i2s_master.v                     \
             ../src/rtl/i2c_wrapper.v                    \
             ../src/rtl/alaw_coder.v                     \
             ../src/rtl/main_fsm.v                       \
             ../src/rtl/mcp4812.v                        \
             ../src/rtl/ram_256k.v                       \
             ../src/rtl/spi_slave.v                      \
             ../src/rtl/sqrt.v                           \
             ../src/rtl/memory_mux.v                     \
             ../src/rtl/adc_receiver.v                   \
             ../src/rtl/top.v                            \
             ../src/tb/ad9629.sv                         \
             ../src/tb/i2c_if.sv                         \
             ../src/tb/mcp4812_imit.sv                   \
             ../src/tb/mi_if.sv                          \
             ../src/tb/$tb_name.sv]                      \
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
      } elseif [regexp {.sv?$} $file] {
        vlog -sv -timescale "1 ns / 1 ps" $file
      } else {
        vlog +define+SIMULATION -timescale "1 ns / 1 ps" $file
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

.main clear

run -all