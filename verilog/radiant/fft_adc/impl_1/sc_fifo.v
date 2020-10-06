// Verilog netlist produced by program LSE 
// Netlist written on Wed Sep 23 23:40:59 2020
// Source file index table: 
// Object locations will have the form @<file_index>(<first_ line>[<left_column>],<last_line>[<right_column>])
// file 0 "/opt/lscc/radiant/2.0/ip/common/adder/rtl/lscc_adder.v"
// file 1 "/opt/lscc/radiant/2.0/ip/common/adder_subtractor/rtl/lscc_add_sub.v"
// file 2 "/opt/lscc/radiant/2.0/ip/common/complex_mult/rtl/lscc_complex_mult.v"
// file 3 "/opt/lscc/radiant/2.0/ip/common/counter/rtl/lscc_cntr.v"
// file 4 "/opt/lscc/radiant/2.0/ip/common/fifo/rtl/lscc_fifo.v"
// file 5 "/opt/lscc/radiant/2.0/ip/common/fifo_dc/rtl/lscc_fifo_dc.v"
// file 6 "/opt/lscc/radiant/2.0/ip/common/mult_accumulate/rtl/lscc_mult_accumulate.v"
// file 7 "/opt/lscc/radiant/2.0/ip/common/mult_add_sub/rtl/lscc_mult_add_sub.v"
// file 8 "/opt/lscc/radiant/2.0/ip/common/mult_add_sub_sum/rtl/lscc_mult_add_sub_sum.v"
// file 9 "/opt/lscc/radiant/2.0/ip/common/multiplier/rtl/lscc_multiplier.v"
// file 10 "/opt/lscc/radiant/2.0/ip/common/ram_dp/rtl/lscc_ram_dp.v"
// file 11 "/opt/lscc/radiant/2.0/ip/common/ram_dq/rtl/lscc_ram_dq.v"
// file 12 "/opt/lscc/radiant/2.0/ip/common/rom/rtl/lscc_rom.v"
// file 13 "/opt/lscc/radiant/2.0/ip/common/subtractor/rtl/lscc_subtractor.v"
// file 14 "/opt/lscc/radiant/2.0/ip/pmi/pmi_add.v"
// file 15 "/opt/lscc/radiant/2.0/ip/pmi/pmi_addsub.v"
// file 16 "/opt/lscc/radiant/2.0/ip/pmi/pmi_complex_mult.v"
// file 17 "/opt/lscc/radiant/2.0/ip/pmi/pmi_counter.v"
// file 18 "/opt/lscc/radiant/2.0/ip/pmi/pmi_dsp.v"
// file 19 "/opt/lscc/radiant/2.0/ip/pmi/pmi_fifo.v"
// file 20 "/opt/lscc/radiant/2.0/ip/pmi/pmi_fifo_dc.v"
// file 21 "/opt/lscc/radiant/2.0/ip/pmi/pmi_mac.v"
// file 22 "/opt/lscc/radiant/2.0/ip/pmi/pmi_mult.v"
// file 23 "/opt/lscc/radiant/2.0/ip/pmi/pmi_multaddsub.v"
// file 24 "/opt/lscc/radiant/2.0/ip/pmi/pmi_multaddsubsum.v"
// file 25 "/opt/lscc/radiant/2.0/ip/pmi/pmi_ram_dp.v"
// file 26 "/opt/lscc/radiant/2.0/ip/pmi/pmi_ram_dp_be.v"
// file 27 "/opt/lscc/radiant/2.0/ip/pmi/pmi_ram_dq.v"
// file 28 "/opt/lscc/radiant/2.0/ip/pmi/pmi_ram_dq_be.v"
// file 29 "/opt/lscc/radiant/2.0/ip/pmi/pmi_rom.v"
// file 30 "/opt/lscc/radiant/2.0/ip/pmi/pmi_sub.v"
// file 31 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/CCU2_B.v"
// file 32 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/FD1P3BZ.v"
// file 33 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/FD1P3DZ.v"
// file 34 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/FD1P3IZ.v"
// file 35 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/FD1P3JZ.v"
// file 36 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/HSOSC.v"
// file 37 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/HSOSC1P8V.v"
// file 38 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/IB.v"
// file 39 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/IFD1P3AZ.v"
// file 40 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/LSOSC.v"
// file 41 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/LSOSC1P8V.v"
// file 42 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/OB.v"
// file 43 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/OBZ_B.v"
// file 44 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/OFD1P3AZ.v"
// file 45 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/PDP4K.v"
// file 46 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/RGB.v"
// file 47 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/RGB1P8V.v"
// file 48 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/SP256K.v"
// file 49 "/opt/lscc/radiant/2.0/cae_library/simulation/verilog/iCE40UP/legacy.v"

//
// Verilog Description of module sc_fifo
//

module sc_fifo (clk_i, rst_i, wr_en_i, rd_en_i, wr_data_i, full_o, 
            empty_o, almost_full_o, almost_empty_o, rd_data_o);
    input clk_i;
    input rst_i;
    input wr_en_i;
    input rd_en_i;
    input [15:0]wr_data_i;
    output full_o;
    output empty_o;
    output almost_full_o;
    output almost_empty_o;
    output [15:0]rd_data_o;
    
    
    
endmodule
