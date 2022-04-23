onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_dft/tb_clk
add wave -noupdate /tb_dft/send_data/task_send_data/i
add wave -noupdate /tb_dft/data_in
add wave -noupdate /tb_dft/valid_in
add wave -noupdate /tb_dft/ready
add wave -noupdate -radix hexadecimal /tb_dft/data_out
add wave -noupdate /tb_dft/valid_out
add wave -noupdate /tb_dft/result_read/task_result_read/i
add wave -noupdate -divider PREPROC
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/clk
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/rst
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/data_in
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/valid_in
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/data_out
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/valid_out
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/fsm_state
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/fsm_next
add wave -noupdate -expand -group preproc /tb_dft/dut/preproc/avg
add wave -noupdate -divider FIFO
add wave -noupdate /tb_dft/fifo_we_cnt
add wave -noupdate /tb_dft/fifo_wr_cnt
add wave -noupdate /tb_dft/fifo_rd_cnt
add wave -noupdate /tb_dft/fifo_re_cnt
add wave -noupdate -group fifo /tb_dft/dut/fifo/clk
add wave -noupdate -group fifo /tb_dft/dut/fifo/rst
add wave -noupdate -group fifo -radix decimal /tb_dft/dut/fifo/wdata
add wave -noupdate -group fifo /tb_dft/dut/fifo/wr
add wave -noupdate -group fifo /tb_dft/dut/fifo/full
add wave -noupdate -group fifo -radix decimal /tb_dft/dut/fifo/rdata
add wave -noupdate -group fifo /tb_dft/dut/fifo/rd
add wave -noupdate -group fifo /tb_dft/dut/fifo/empty
add wave -noupdate -group fifo -radix unsigned /tb_dft/dut/fifo/load
add wave -noupdate -group fifo -radix decimal /tb_dft/dut/fifo/waddr
add wave -noupdate -group fifo -radix decimal /tb_dft/dut/fifo/waddr_next
add wave -noupdate -group fifo -radix decimal /tb_dft/dut/fifo/raddr
add wave -noupdate -group fifo -radix decimal /tb_dft/dut/fifo/raddr_next
add wave -noupdate -group fifo /tb_dft/dut/fifo/we
add wave -noupdate -group fifo /tb_dft/dut/fifo/re
add wave -noupdate -divider POSTPROC
add wave -noupdate /tb_dft/dut/postproc/clk
add wave -noupdate /tb_dft/dut/postproc/rst
add wave -noupdate -radix decimal /tb_dft/dut/postproc/data_re_in
add wave -noupdate -radix decimal /tb_dft/dut/postproc/data_im_in
add wave -noupdate /tb_dft/dut/postproc/valid_in
add wave -noupdate -radix hexadecimal /tb_dft/dut/postproc/data_out
add wave -noupdate /tb_dft/dut/postproc/valid_out
add wave -noupdate /tb_dft/dut/postproc/fsm_state
add wave -noupdate /tb_dft/dut/postproc/fsm_next
add wave -noupdate -radix unsigned /tb_dft/dut/postproc/avg
add wave -noupdate -radix decimal /tb_dft/dut/postproc/mul_0
add wave -noupdate -radix decimal /tb_dft/dut/postproc/mul_1
add wave -noupdate -radix unsigned /tb_dft/dut/postproc/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85790385 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 318
configure wave -valuecolwidth 75
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {398232152 ps}
