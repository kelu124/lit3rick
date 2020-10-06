// =============================================================================
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
// -----------------------------------------------------------------------------
//   Copyright (c) 2018 by Lattice Semiconductor Corporation
//   ALL RIGHTS RESERVED
// --------------------------------------------------------------------
//
//   Permission:
//
//      Lattice SG Pte. Ltd. grants permission to use this code
//      pursuant to the terms of the Lattice Reference Design License Agreement.
//
//
//   Disclaimer:
//
//      This VHDL or Verilog source code is intended as a design reference
//      which illustrates how these types of functions can be implemented.
//      It is the user's responsibility to verify their design for
//      consistency and functionality through the use of formal
//      verification methods.  Lattice provides no warranty
//      regarding the use or functionality of this code.
//
// -----------------------------------------------------------------------------
//
//                  Lattice SG Pte. Ltd.
//                  101 Thomson Road, United Square #07-02
//                  Singapore 307591
//
//
//                  TEL: 1-800-Lattice (USA and Canada)
//                       +65-6631-2000 (Singapore)
//                       +1-503-268-8001 (other locations)
//
//                  web: http://www.latticesemi.com/
//                  email: techsupport@latticesemi.com
//
// -----------------------------------------------------------------------------
//
// =============================================================================
//                         FILE DETAILS
// Project               :
// File                  : tb_top.v
// Title                 : Testbench for fifo.
// Dependencies          : 1.
//                       : 2.
// Description           :
// =============================================================================
//                        REVISION HISTORY
// Version               : 1.0.1
// Author(s)             :
// Mod. Date             : 03/05/2018
// Changes Made          : Initial version of testbench for fifo
// =============================================================================

`ifndef TB_TOP
`define TB_TOP

//==========================================================================
// Module : tb_top
//==========================================================================

`timescale 1ns/1ns

module tb_top();

`include "dut_params.v"

localparam CLK_FREQ = (FAMILY == "iCE40UP") ? 40 : 10;
localparam RESET_CNT = (FAMILY == "iCE40UP") ? 140 : 35;

reg clk_i;
reg [DATA_WIDTH-1:0] wr_data_i;
reg wr_en_i;
reg rd_en_i;
reg rst_i;

reg [ADDRESS_WIDTH-1:0] almost_full_th_i = ADDRESS_DEPTH*9/10;
reg [ADDRESS_WIDTH-1:0] almost_full_clr_th_i = ADDRESS_DEPTH*8/10;
reg [ADDRESS_WIDTH-1:0] almost_empty_th_i = ADDRESS_DEPTH/10;
reg [ADDRESS_WIDTH-1:0] almost_empty_clr_th_i = ADDRESS_DEPTH*2/10;

wire [DATA_WIDTH-1:0] rd_data_o;

wire full_o;
wire empty_o;
wire almost_full_o;
wire almost_empty_o;
wire [ADDRESS_WIDTH:0] data_cnt_o;

if(ENABLE_DATA_COUNT == "FALSE") begin
    assign data_cnt_o = {(ADDRESS_WIDTH+1){1'b0}};
end

`ifdef LIFCL
    // ----------------------------
    // LIFCL GSR instance
    // ----------------------------
    reg CLK_GSR = 0;
    reg USER_GSR = 1;
    wire GSROUT;
    
    initial begin
        forever begin
            #5;
            CLK_GSR = ~CLK_GSR;
        end
    end
    
    GSR GSR_INST (
        .GSR_N(USER_GSR),
        .CLK(CLK_GSR)
    );
`endif

`include "dut_inst.v"
wire full_test_o;
wire empty_test_o;
wire afull_test_o;
wire aempty_test_o;
wire [ADDRESS_WIDTH:0] data_cnt_test_o;

reg full_latch_r;
reg empty_latch_r;
reg afull_latch_r;
reg aempty_latch_r;
reg data_cnt_latch_r;

begin : misc_check
    wire full_chk_w   = full_test_o == full_o;
    wire empty_chk_w  = empty_test_o == empty_o;
    wire afull_chk_w  = afull_test_o == almost_full_o;
    wire aempty_chk_w = aempty_test_o == almost_empty_o;
    wire data_chk_w   = data_cnt_test_o == data_cnt_o;

    reg del_r;
    
    always @ (posedge clk_i, posedge rst_i) begin
        if(rst_i) begin
            del_r <= 1'b1;
            full_latch_r <= 1'b1;
            empty_latch_r <= 1'b1;
        end
        else begin
            del_r <= 1'b0;
            full_latch_r <= (del_r) | (full_latch_r & full_chk_w);
            empty_latch_r <= (del_r) | (empty_latch_r & empty_chk_w);
        end
    end

    if(ENABLE_ALMOST_EMPTY_FLAG == "TRUE") begin
        always @ (posedge clk_i, posedge rst_i) begin
            if(rst_i) begin
                aempty_latch_r <= 1'b1;
            end
            else begin
                aempty_latch_r <= (del_r) | (aempty_latch_r & aempty_chk_w);
            end
        end
    end

    if(ENABLE_ALMOST_FULL_FLAG == "TRUE") begin
        always @ (posedge clk_i, posedge rst_i) begin
            if(rst_i) begin
                afull_latch_r <= 1'b1;
            end
            else begin
                afull_latch_r <= (del_r) | (afull_latch_r & afull_chk_w);
            end
        end
    end

    if(ENABLE_DATA_COUNT == "TRUE") begin
        always @ (posedge clk_i, posedge rst_i) begin
            if(rst_i) begin
                data_cnt_latch_r <= 1'b1;
            end
            else begin
                data_cnt_latch_r <= (del_r) | (data_cnt_latch_r & data_chk_w);
            end
        end
    end

end

lscc_test_fifo # (
    .FAMILY                    (FAMILY),
    .ADDRESS_DEPTH             (ADDRESS_DEPTH),
    .ADDRESS_WIDTH             (ADDRESS_WIDTH),
    .REGMODE                   (REGMODE),
    .RESET_MODE                (RESET_MODE),
    .ENABLE_ALMOST_FULL_FLAG   (ENABLE_ALMOST_FULL_FLAG),
    .ALMOST_FULL_ASSERTION     (ALMOST_FULL_ASSERTION),
    .ALMOST_FULL_ASSERT_LVL    (ALMOST_FULL_ASSERT_LVL),
    .ALMOST_FULL_DEASSERT_LVL  (ALMOST_FULL_DEASSERT_LVL),
    .ENABLE_ALMOST_EMPTY_FLAG  (ENABLE_ALMOST_EMPTY_FLAG),
    .ALMOST_EMPTY_ASSERTION    (ALMOST_EMPTY_ASSERTION),
    .ALMOST_EMPTY_ASSERT_LVL   (ALMOST_EMPTY_ASSERT_LVL),
    .ALMOST_EMPTY_DEASSERT_LVL (ALMOST_EMPTY_DEASSERT_LVL),
    .ENABLE_DATA_COUNT         (ENABLE_DATA_COUNT),
    .IMPLEMENTATION            (IMPLEMENTATION)
) flag_check (
    .clk_i                     (clk_i), 
    .rst_i                     (rst_i), 
    .wr_en_i                   (wr_en_i), 
    .rd_en_i                   (rd_en_i),
    .almost_full_th_i          (almost_full_th_i), 
    .almost_full_clr_th_i      (almost_full_clr_th_i), 
    .almost_empty_th_i         (almost_empty_th_i), 
    .almost_empty_clr_th_i     (almost_empty_clr_th_i),

    .full_o                    (full_test_o), 
    .empty_o                   (empty_test_o), 
    .almost_full_o             (afull_test_o), 
    .almost_empty_o            (aempty_test_o), 
    .data_cnt_o                (data_cnt_test_o)
);

initial begin
	rst_i = 1'b1;
	#RESET_CNT;
	rst_i = 1'b0;
end

initial begin
	clk_i = 1'b0;
	forever #CLK_FREQ clk_i = ~clk_i;
end

parameter FIFO_WRITE     = ADDRESS_DEPTH;
parameter FIFO_READ	     = ADDRESS_DEPTH;
parameter FIFO_DELAY     = 5;

reg chk = 1'b1;

integer i0;

initial begin
    @(negedge rst_i);
	wr_en_i <= 1'b1;
	rd_en_i <= 1'b0;
	wr_data_i <= $urandom_range(256'h0000000000000000000000000000000000000000000000000000000000000000,256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
	@(posedge clk_i);
	for(i0 = 0; i0 < FIFO_WRITE; i0 = i0 + 1) begin
		@(posedge clk_i);
		wr_data_i <= $urandom_range(256'h0000000000000000000000000000000000000000000000000000000000000000,256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
	end
	wr_en_i <= 1'b0;
	for(i0 = 0; i0 < FIFO_DELAY; i0 = i0 + 1) begin
		@(posedge clk_i);
	end
	rd_en_i <= 1'b1;
	for(i0 = 0; i0 < FIFO_READ; i0 = i0 + 1) begin
		@(posedge clk_i);
	end
    if(REGMODE == "reg") @(posedge clk_i);
    if(chk == 1'b1) begin
        $display("-----------------------------------------------------");
        $display("----------------- DATA CHECK PASSED -----------------");
        $display("-----------------------------------------------------");
    end
    else begin
        $display("-----------------------------------------------------");
        $display("!!!!!!!!!!!!!!!!! DATA CHECK FAILED !!!!!!!!!!!!!!!!!");
        $display("-----------------------------------------------------");
    end
    if(full_latch_r) begin
        $display("## FULL Flag Check: PASSED");
    end
    else begin
        $display("## FULL Flag Check: FAILED");
    end

    if(empty_latch_r) begin
        $display("## EMPTY Flag Check: PASSED");
    end
    else begin
        $display("## EMPTY Flag Check: FAILED");
    end

    if(ENABLE_ALMOST_FULL_FLAG == "TRUE") begin
        if(afull_latch_r) begin
            $display("## ALMOST FULL Flag Check: PASSED");
        end
        else begin
            $display("## ALMOST FULL Flag Check: FAILED");
        end
    end

    if(ENABLE_ALMOST_EMPTY_FLAG == "TRUE") begin
        if(aempty_latch_r) begin
            $display("## ALMOST EMPTY Flag Check: PASSED");
        end
        else begin
            $display("## ALMOST EMPTY Flag Check: FAILED");
        end
    end

    if(ENABLE_DATA_COUNT == "TRUE") begin
        if(data_cnt_latch_r) begin
            $display("## Data Count Check: PASSED");
        end
        else begin
            $display("## Data Count Check: FAILED");
        end
    end

    if(chk & full_latch_r & empty_latch_r & 
      (ENABLE_ALMOST_FULL_FLAG == "TRUE" ? afull_latch_r : 1'b1) &
      (ENABLE_ALMOST_EMPTY_FLAG == "TRUE" ? aempty_latch_r : 1'b1) &
      (ENABLE_DATA_COUNT == "TRUE" ? data_cnt_latch_r : 1'b1)
       ) begin
        $display("-----------------------------------------------------");
        $display("----------------- SIMULATION PASSED -----------------");
        $display("-----------------------------------------------------");
    end
    else begin
        $display("-----------------------------------------------------");
        $display("!!!!!!!!!!!!!!!!! SIMULATION FAILED !!!!!!!!!!!!!!!!!");
        $display("-----------------------------------------------------");
    end

	$finish;
end

reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0];
reg [ADDRESS_WIDTH-1:0] wr_addr_r = {ADDRESS_WIDTH{1'b0}};
reg [ADDRESS_WIDTH-1:0] rd_addr_r = {ADDRESS_WIDTH{1'b0}};

always @ (posedge clk_i, posedge rst_i) begin
    if(rst_i == 1'b1) begin
        wr_addr_r = {ADDRESS_WIDTH{1'b0}};
    end
    else begin
        if(wr_en_i == 1'b1) begin
            wr_addr_r <= wr_addr_r + 1;
        end
    end
end

always @ (posedge clk_i) begin
    if(wr_en_i == 1'b1 && rst_i == 1'b0 && full_o == 1'b0) begin
        mem[wr_addr_r] <= wr_data_i;
    end
end

always @ (posedge clk_i, posedge rst_i) begin
    if(rst_i == 1'b1) begin
        rd_addr_r = {ADDRESS_WIDTH{1'b0}};
    end
    else begin
        if(rd_en_i == 1'b1) begin
            rd_addr_r <= rd_addr_r + 1;
        end
    end
end

if(REGMODE == "noreg") begin
    reg [ADDRESS_WIDTH-1:0] rd_addr_p_r = {ADDRESS_WIDTH{1'b0}};
    reg rd_en_p_r = 1'b0;
    always @ (posedge clk_i) begin
        rd_addr_p_r <= rd_addr_r;
        rd_en_p_r <= rd_en_i;
    end
    always @ (posedge clk_i) begin
        if(rd_en_p_r == 1'b1 && rst_i == 1'b0) begin
            if(mem[rd_addr_p_r] != rd_data_o) begin
                chk = 1'b0;
                $display("Expected DATA = %h, Read DATA = %h", mem[rd_addr_p_r], rd_data_o);
            end
        end
    end
end
else begin
    reg [ADDRESS_WIDTH-1:0] rd_addr_p_r  = {ADDRESS_WIDTH{1'b0}};
    reg [ADDRESS_WIDTH-1:0] rd_addr_p2_r = {ADDRESS_WIDTH{1'b0}};
    reg rd_en_p_r  = 1'b0;
    reg rd_en_p2_r = 1'b0;
    always @ (posedge clk_i) begin
        rd_addr_p_r <= rd_addr_r;
        rd_en_p_r <= rd_en_i;
        rd_addr_p2_r <= rd_addr_p_r;
        rd_en_p2_r <= rd_en_p_r;
    end
    always @ (posedge clk_i) begin
        if(rd_en_p2_r == 1'b1 && rst_i == 1'b0) begin
            if(mem[rd_addr_p2_r] != rd_data_o) begin
                chk = 1'b0;
                $display("Expected DATA = %h, Read DATA = %h", mem[rd_addr_p2_r], rd_data_o);
            end
        end
    end
end

endmodule
`endif

`ifndef LSCC_TEST_FIFO
`define LSCC_TEST_FIFO

module lscc_test_fifo
#(//--begin_param--
//----------------------------
// Parameters
//----
    parameter              IMPLEMENTATION            = "EBR",
    parameter              ADDRESS_DEPTH             = 512,
    parameter              ADDRESS_WIDTH             = ADDRESS_DEPTH,
    parameter              REGMODE                   = "reg",
    parameter              RESET_MODE                = "async",
    parameter              ENABLE_ALMOST_FULL_FLAG   = "TRUE",
    parameter              ENABLE_ALMOST_EMPTY_FLAG  = "TRUE",
    parameter              ALMOST_FULL_ASSERTION     = "static-dual",
    parameter              ALMOST_FULL_ASSERT_LVL    = 1023,
    parameter              ALMOST_FULL_DEASSERT_LVL  = 1020,
    parameter              ALMOST_EMPTY_ASSERTION    = "static-dual",
    parameter              ALMOST_EMPTY_ASSERT_LVL   = 1,
    parameter              ALMOST_EMPTY_DEASSERT_LVL = 4,
    parameter              ENABLE_DATA_COUNT         = "FALSE",
    parameter              FAMILY                    = "common"
) //--end_param--
(//--begin_ports--
//----------------------------
// Inputs
//----------------------------
    input clk_i,
    input wr_en_i,
    input rd_en_i,
    input rst_i,
    
    input [ADDRESS_WIDTH-1:0] almost_full_th_i,
    input [ADDRESS_WIDTH-1:0] almost_full_clr_th_i,
    input [ADDRESS_WIDTH-1:0] almost_empty_th_i,
    input [ADDRESS_WIDTH-1:0] almost_empty_clr_th_i,

//----------------------------
// Outputs
//----------------------------
    
    output full_o,
    output empty_o,
    output almost_full_o,
    output almost_empty_o,
    output [ADDRESS_WIDTH:0] data_cnt_o
    
); //--end_ports--

//----------------------------
// Wire and Registers
//----------------------------

reg full_r     ;
reg full_ext_r ;
reg wr_en_i_mem ;

reg empty_r     ;
reg empty_ext_r ;
reg rd_en_i_mem ;

reg [ADDRESS_WIDTH:0]     wr_addr_r       ;
reg [ADDRESS_WIDTH:0]     wr_addr_p1_r    ;
reg [ADDRESS_WIDTH:0]     wr_addr_p1cmp_r ;
reg [ADDRESS_WIDTH-1:0]   wr_cmpaddr_r    ;
reg [ADDRESS_WIDTH-1:0]   waddr_r         ;
reg [ADDRESS_WIDTH-1:0]   wr_cmpaddr_p1_r ;

reg [ADDRESS_WIDTH:0]     rd_addr_r       ;
reg [ADDRESS_WIDTH:0]     rd_addr_p1_r    ;
reg [ADDRESS_WIDTH:0]     rd_addr_p1cmp_r ;
reg [ADDRESS_WIDTH-1:0]   rd_cmpaddr_r    ;
reg [ADDRESS_WIDTH-1:0]   raddr_r         ;
reg [ADDRESS_WIDTH-1:0]   rd_cmpaddr_p1_r ;

// WRITE address controller
wire [ADDRESS_WIDTH:0]    wr_addr_nxt_w     = (wr_en_i & ~full_r) ? wr_addr_p1_r : wr_addr_r;
wire [ADDRESS_WIDTH:0]    wr_addr_nxt_p1_w  = wr_addr_nxt_w + 1'b1;

// READ address controller									    
wire [ADDRESS_WIDTH:0]    rd_addr_nxt_w     = (rd_en_i & ~empty_r) ? rd_addr_p1_r : rd_addr_r;
wire [ADDRESS_WIDTH:0]    rd_addr_nxt_p1_w  = rd_addr_nxt_w + 1'b1;

// Flag controller
wire full_nxt_w                             = ((wr_en_i & ~full_r) & (wr_cmpaddr_p1_r == rd_cmpaddr_r) & (wr_addr_p1cmp_r[ADDRESS_WIDTH] != rd_addr_r[ADDRESS_WIDTH])) ||  
                                              (~((wr_cmpaddr_r != rd_cmpaddr_r) || rd_en_i) & full_r);
wire empty_nxt_w                            = ((rd_en_i & ~empty_r) & (rd_addr_p1cmp_r == wr_addr_r)) || (~((wr_cmpaddr_r != rd_cmpaddr_r) || wr_en_i) & empty_r);

assign full_o  = full_ext_r;
assign empty_o = empty_ext_r;

//----------------------------
// Sequential Circuit
//----------------------------

if(RESET_MODE == "sync") begin : MASTER_SYNC
    always @ (posedge clk_i) begin
        if(rst_i) begin
            full_ext_r      <= 1'b0;
            full_r          <= 1'b0;
            wr_en_i_mem     <= 1'b1;

            empty_ext_r     <= 1'b1;
            empty_r         <= 1'b1;
            rd_en_i_mem     <= 1'b0;
    
            wr_addr_r       <= {(ADDRESS_WIDTH + 1) {1'b0}};
            wr_addr_p1_r    <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            wr_cmpaddr_r    <= {(ADDRESS_WIDTH) {1'b0}};
            wr_addr_p1cmp_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            waddr_r         <= {(ADDRESS_WIDTH) {1'b0}};
            wr_cmpaddr_p1_r <= {{(ADDRESS_WIDTH-1){1'b0}}, 1'b1};
    
            rd_addr_r       <= {(ADDRESS_WIDTH + 1) {1'b0}};
            rd_addr_p1_r    <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            rd_addr_p1cmp_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            rd_cmpaddr_r    <= {(ADDRESS_WIDTH) {1'b0}};
            raddr_r         <= {(ADDRESS_WIDTH) {1'b0}};
            rd_cmpaddr_p1_r <= {{(ADDRESS_WIDTH-1){1'b0}}, 1'b1};
        end
        else begin
            full_ext_r      <= full_nxt_w;
            full_r          <= full_nxt_w;
            wr_en_i_mem     <= ((rd_en_i & ~empty_r) & (rd_addr_p1cmp_r == wr_addr_r)) || (~((wr_cmpaddr_r != rd_cmpaddr_r) || wr_en_i) & empty_r);

            empty_ext_r     <= empty_nxt_w;
            empty_r         <= empty_nxt_w;
            rd_en_i_mem     <= ((wr_en_i & ~full_r) & (wr_cmpaddr_p1_r == rd_cmpaddr_r) & (wr_addr_p1cmp_r[ADDRESS_WIDTH] != rd_addr_r[ADDRESS_WIDTH])) ||  
                               (~((wr_cmpaddr_r != rd_cmpaddr_r) || rd_en_i) & full_r);
    
            wr_addr_r       <= wr_addr_nxt_w;
            wr_addr_p1_r    <= wr_addr_nxt_p1_w;
            wr_cmpaddr_r    <= wr_addr_nxt_w[ADDRESS_WIDTH-1:0];
            wr_addr_p1cmp_r <= wr_addr_nxt_p1_w;
            waddr_r         <= wr_addr_nxt_w[ADDRESS_WIDTH-1:0];
            wr_cmpaddr_p1_r <= wr_addr_nxt_p1_w[ADDRESS_WIDTH-1:0];
    
            rd_addr_r       <= rd_addr_nxt_w;
            rd_addr_p1_r    <= rd_addr_nxt_p1_w;
            rd_addr_p1cmp_r <= rd_addr_nxt_p1_w;
            rd_cmpaddr_r    <= rd_addr_nxt_w[ADDRESS_WIDTH-1:0];
            raddr_r         <= rd_addr_nxt_w[ADDRESS_WIDTH-1:0];
            rd_cmpaddr_p1_r <= rd_addr_nxt_p1_w[ADDRESS_WIDTH-1:0];
        end
    end
end
else begin : MASTER_ASYNC
    always @ (posedge clk_i, posedge rst_i) begin
        if(rst_i) begin
            full_ext_r      <= 1'b0;
            full_r          <= 1'b0;
            wr_en_i_mem     <= 1'b1;

            empty_ext_r     <= 1'b1;
            empty_r         <= 1'b1;
            rd_en_i_mem     <= 1'b0;
    
            wr_addr_r       <= {(ADDRESS_WIDTH + 1) {1'b0}};
            wr_addr_p1_r    <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            wr_cmpaddr_r    <= {(ADDRESS_WIDTH) {1'b0}};
            wr_addr_p1cmp_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            waddr_r         <= {(ADDRESS_WIDTH) {1'b0}};
            wr_cmpaddr_p1_r <= {{(ADDRESS_WIDTH-1){1'b0}}, 1'b1};
    
            rd_addr_r       <= {(ADDRESS_WIDTH + 1) {1'b0}};
            rd_addr_p1_r    <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            rd_addr_p1cmp_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
            rd_cmpaddr_r    <= {(ADDRESS_WIDTH) {1'b0}};
            raddr_r         <= {(ADDRESS_WIDTH) {1'b0}};
            rd_cmpaddr_p1_r <= {{(ADDRESS_WIDTH-1){1'b0}}, 1'b1};
        end
        else begin
            full_ext_r      <= full_nxt_w;
            full_r          <= full_nxt_w;
            wr_en_i_mem     <= ((rd_en_i & ~empty_r) & (rd_addr_p1cmp_r == wr_addr_r)) || (~((wr_cmpaddr_r != rd_cmpaddr_r) || wr_en_i) & empty_r);

            empty_ext_r     <= empty_nxt_w;
            empty_r         <= empty_nxt_w;
            rd_en_i_mem     <= ((wr_en_i & ~full_r) & (wr_cmpaddr_p1_r == rd_cmpaddr_r) & (wr_addr_p1cmp_r[ADDRESS_WIDTH] != rd_addr_r[ADDRESS_WIDTH])) ||  
                               (~((wr_cmpaddr_r != rd_cmpaddr_r) || rd_en_i) & full_r);
    
            wr_addr_r       <= wr_addr_nxt_w;
            wr_addr_p1_r    <= wr_addr_nxt_p1_w;
            wr_cmpaddr_r    <= wr_addr_nxt_w[ADDRESS_WIDTH-1:0];
            wr_addr_p1cmp_r <= wr_addr_nxt_p1_w;
            waddr_r         <= wr_addr_nxt_w[ADDRESS_WIDTH-1:0];
            wr_cmpaddr_p1_r <= wr_addr_nxt_p1_w[ADDRESS_WIDTH-1:0];
    
            rd_addr_r       <= rd_addr_nxt_w;
            rd_addr_p1_r    <= rd_addr_nxt_p1_w;
            rd_addr_p1cmp_r <= rd_addr_nxt_p1_w;
            rd_cmpaddr_r    <= rd_addr_nxt_w[ADDRESS_WIDTH-1:0];
            raddr_r         <= rd_addr_nxt_w[ADDRESS_WIDTH-1:0];
            rd_cmpaddr_p1_r <= rd_addr_nxt_p1_w[ADDRESS_WIDTH-1:0];
        end
    end
end

//----------------------------
// MISCELLANEOUS Features
//----------------------------

if(ENABLE_ALMOST_FULL_FLAG == "TRUE" || ENABLE_ALMOST_EMPTY_FLAG == "TRUE" || ENABLE_DATA_COUNT == "TRUE") begin : MISC
    reg full_flag_r   ;
    reg empty_flag_r  ;
    reg [ADDRESS_WIDTH:0] wr_flag_addr_r    ;
    reg [ADDRESS_WIDTH:0] wr_flag_addr_p1_r ;
    reg [ADDRESS_WIDTH:0] rd_flag_addr_r    ;
    reg [ADDRESS_WIDTH:0] rd_flag_addr_p1_r ;
    
    wire [ADDRESS_WIDTH:0] diff_norm_w = wr_flag_addr_r - rd_flag_addr_r;
    wire [ADDRESS_WIDTH:0] diff_wr_w   = wr_flag_addr_p1_r - rd_flag_addr_r;
    wire [ADDRESS_WIDTH:0] diff_rd_w   = wr_flag_addr_r - rd_flag_addr_p1_r;

    wire wr_w = wr_en_i & ~full_flag_r;
    wire rd_w = rd_en_i & ~empty_flag_r;

    wire [ADDRESS_WIDTH:0] diff_w      = (wr_w == rd_w) ? diff_norm_w : (wr_w) ? diff_wr_w : diff_rd_w;

    if(RESET_MODE == "sync") begin : SYNC_CON
        always @ (posedge clk_i) begin
            if(rst_i) begin
                wr_flag_addr_r    <= {(ADDRESS_WIDTH+1){1'b0}};
                wr_flag_addr_p1_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
                rd_flag_addr_r    <= {(ADDRESS_WIDTH+1){1'b0}};
                rd_flag_addr_p1_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
                full_flag_r       <= 1'b0;
                empty_flag_r      <= 1'b1;
            end
            else begin
                wr_flag_addr_r    <= wr_addr_nxt_w;
                wr_flag_addr_p1_r <= wr_addr_nxt_p1_w;
                rd_flag_addr_r    <= rd_addr_nxt_w;
                rd_flag_addr_p1_r <= rd_addr_nxt_p1_w;
                full_flag_r       <= full_nxt_w;
                empty_flag_r      <= empty_nxt_w;
            end
        end
    end
    else begin : ASYNC_CON
        always @ (posedge clk_i, posedge rst_i) begin
            if(rst_i) begin
                wr_flag_addr_r    <= {(ADDRESS_WIDTH+1){1'b0}};
                wr_flag_addr_p1_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
                rd_flag_addr_r    <= {(ADDRESS_WIDTH+1){1'b0}};
                rd_flag_addr_p1_r <= {{(ADDRESS_WIDTH){1'b0}}, 1'b1};
                full_flag_r       <= 1'b0;
                empty_flag_r      <= 1'b1;
            end
            else begin
                wr_flag_addr_r    <= wr_addr_nxt_w;
                wr_flag_addr_p1_r <= wr_addr_nxt_p1_w;
                rd_flag_addr_r    <= rd_addr_nxt_w;
                rd_flag_addr_p1_r <= rd_addr_nxt_p1_w;
                full_flag_r       <= full_nxt_w;
                empty_flag_r      <= empty_nxt_w;
            end
        end
    end

    // Almost Flag Controller
    if(ENABLE_ALMOST_FULL_FLAG == "TRUE") begin : AFull
        wire [ADDRESS_WIDTH-1:0] almost_full_tick_w      = (ALMOST_FULL_ASSERTION == "static-single" || ALMOST_FULL_ASSERTION == "static-dual") ? ALMOST_FULL_ASSERT_LVL : almost_full_th_i;
        wire [ADDRESS_WIDTH-1:0] almost_full_tock_w      = (ALMOST_FULL_ASSERTION == "static-single") ? ALMOST_FULL_ASSERT_LVL : 
                                                           (ALMOST_FULL_ASSERTION == "static-dual") ? ALMOST_FULL_DEASSERT_LVL :
                                                           (ALMOST_FULL_ASSERTION == "dynamic-single") ? almost_full_th_i : almost_full_clr_th_i;
        reg  almost_full_r;
        reg  almost_full_ext_r;
        wire almost_full_nxt_w;
        if(ALMOST_FULL_ASSERTION == "static-single" || ALMOST_FULL_ASSERTION == "dynamic-single") begin
            assign almost_full_nxt_w = ~(diff_w < almost_full_tick_w);
        end
        else begin
            assign almost_full_nxt_w = (~(diff_w < almost_full_tick_w)) | (diff_w > almost_full_tock_w) & almost_full_r;
        end

        assign almost_full_o = almost_full_ext_r;


        if(RESET_MODE == "sync") begin
            always @ (posedge clk_i) begin
                if(rst_i) begin
                    almost_full_ext_r <= 1'b0;
                    almost_full_r     <= 1'b0;
                end
                else begin
                    almost_full_ext_r <= almost_full_nxt_w;
                    almost_full_r     <= almost_full_nxt_w;
                end
            end
        end
        else begin
            always @ (posedge clk_i, posedge rst_i) begin
                if(rst_i) begin
                    almost_full_ext_r <= 1'b0;
                    almost_full_r     <= 1'b0;
                end
                else begin
                    almost_full_ext_r <= almost_full_nxt_w;
                    almost_full_r     <= almost_full_nxt_w;
                end
            end
        end
    end
    else begin
        assign almost_full_o = 1'b0;
    end

    // Almost Empty Controller
    if(ENABLE_ALMOST_EMPTY_FLAG == "TRUE") begin : AEmpty
        wire [ADDRESS_WIDTH-1:0] almost_empty_tick_w     = (ALMOST_EMPTY_ASSERTION == "static-single" || ALMOST_EMPTY_ASSERTION == "static-dual") ? ALMOST_EMPTY_ASSERT_LVL : almost_empty_th_i;
        wire [ADDRESS_WIDTH-1:0] almost_empty_tock_w     = (ALMOST_EMPTY_ASSERTION == "static-single") ? ALMOST_EMPTY_ASSERT_LVL : 
                                                           (ALMOST_EMPTY_ASSERTION == "static-dual") ? ALMOST_EMPTY_DEASSERT_LVL :
                                                           (ALMOST_EMPTY_ASSERTION == "dynamic-single") ? almost_empty_th_i : almost_empty_clr_th_i;
        reg almost_empty_r;
        reg almost_empty_ext_r;
        wire almost_empty_nxt_w;
        if(ALMOST_EMPTY_ASSERTION == "static-single" || ALMOST_EMPTY_ASSERTION == "dynamic-single") begin
            assign almost_empty_nxt_w = ~(diff_w > almost_empty_tick_w);
        end
        else begin
            assign almost_empty_nxt_w = (diff_w < almost_empty_tock_w) & (~(diff_w > almost_empty_tick_w) | almost_empty_r); 
        end
	    
        assign almost_empty_o = almost_empty_ext_r;
	    	    
        if(RESET_MODE == "sync") begin
            always @ (posedge clk_i) begin
                if(rst_i) begin
                    almost_empty_ext_r <= 1'b1;
                    almost_empty_r     <= 1'b1;
                end
                else begin
                    almost_empty_ext_r <= almost_empty_nxt_w;
                    almost_empty_r     <= almost_empty_nxt_w;
                end
            end
        end
        else begin
            always @ (posedge clk_i, posedge rst_i) begin
                if(rst_i) begin
                    almost_empty_ext_r <= 1'b1;
                    almost_empty_r     <= 1'b1;
                end
                else begin
                    almost_empty_ext_r <= almost_empty_nxt_w;
                    almost_empty_r     <= almost_empty_nxt_w;
                end
            end
        end
    end
    else begin
        assign almost_empty_o = 1'b0;
    end

    // Enable Data Count Controller
    if(ENABLE_DATA_COUNT == "TRUE") begin
        reg [ADDRESS_WIDTH:0] data_cnt_r;
        assign data_cnt_o = data_cnt_r;

        if(RESET_MODE == "sync") begin
            always @ (posedge clk_i) begin
                if(rst_i) begin
                    data_cnt_r <= {(ADDRESS_WIDTH+1){1'b0}};
                end
                else begin
                    data_cnt_r <= diff_w;
                end
            end
        end
        else begin
            always @ (posedge clk_i, posedge rst_i) begin
                if(rst_i) begin
                    data_cnt_r <= {(ADDRESS_WIDTH+1){1'b0}};
                end
                else begin
                    data_cnt_r <= diff_w;
                end
            end
        end
    end
    else begin
        assign data_cnt_o = {(ADDRESS_WIDTH+1){1'b0}};
    end
end

endmodule
`endif