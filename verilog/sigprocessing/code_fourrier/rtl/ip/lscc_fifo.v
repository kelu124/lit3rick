`ifndef LSCC_FIFO
`define LSCC_FIFO

module lscc_fifo
#(//--begin_param--
//----------------------------
// Parameters
//----
    parameter              IMPLEMENTATION            = "EBR",
    parameter              ADDRESS_DEPTH             = 512,
    parameter              ADDRESS_WIDTH             = clog2(ADDRESS_DEPTH),
    parameter              DATA_WIDTH                = 18,
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
    parameter              FAMILY                    = "iCE40UP"
) //--end_param--
(//--begin_ports--
//----------------------------
// Inputs
//----------------------------
    input clk_i,
    input [DATA_WIDTH-1:0] wr_data_i,
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
    
    output [DATA_WIDTH-1:0] rd_data_o,
    
    output full_o,
    output empty_o,
    output almost_full_o,
    output almost_empty_o,
    output [ADDRESS_WIDTH:0] data_cnt_o
    
); //--end_ports--

//----------------------------
// Wire and Registers
//----------------------------

reg full_r     /*synthesis syn_preserve=1*/;
reg full_mem_r /*synthesis syn_preserve=1*/;
reg full_ext_r /*synthesis syn_preserve=1*/;

reg empty_r     /*synthesis syn_preserve=1*/;
reg empty_mem_r /*synthesis syn_preserve=1*/;
reg empty_ext_r /*synthesis syn_preserve=1*/;

reg [ADDRESS_WIDTH:0]     wr_addr_r       /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH:0]     wr_addr_p1_r    /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH:0]     wr_addr_p1cmp_r /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH-1:0]   wr_cmpaddr_r    /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH-1:0]   waddr_r         /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH-1:0]   wr_cmpaddr_p1_r /*synthesis syn_preserve=1*/;

reg [ADDRESS_WIDTH:0]     rd_addr_r       /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH:0]     rd_addr_p1_r    /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH:0]     rd_addr_p1cmp_r /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH-1:0]   rd_cmpaddr_r    /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH-1:0]   raddr_r         /*synthesis syn_preserve=1*/;
reg [ADDRESS_WIDTH-1:0]   rd_cmpaddr_p1_r /*synthesis syn_preserve=1*/;

// WRITE address controller
wire [ADDRESS_WIDTH:0]    wr_addr_nxt_w     = (wr_en_i & ~full_r) ? wr_addr_p1_r : wr_addr_r;
wire [ADDRESS_WIDTH:0]    wr_addr_nxt_p1_w  = wr_addr_nxt_w + 1'b1;

// READ address controller									    
wire [ADDRESS_WIDTH:0]    rd_addr_nxt_w     = (rd_en_i & ~empty_r) ? rd_addr_p1_r : rd_addr_r;
wire [ADDRESS_WIDTH:0]    rd_addr_nxt_p1_w  = rd_addr_nxt_w + 1'b1;

// Flag controller
wire full_nxt_w                             = (~(rd_en_i & ~empty_r) & (wr_en_i & ~full_r) & (wr_cmpaddr_p1_r == rd_cmpaddr_r) & (wr_addr_p1cmp_r[ADDRESS_WIDTH] != rd_addr_r[ADDRESS_WIDTH])) ||  
                                              (~((wr_cmpaddr_r != rd_cmpaddr_r) || rd_en_i) & full_r);
wire empty_nxt_w                            = ((rd_en_i & ~empty_r) & (rd_addr_p1cmp_r == wr_addr_r) & ~(wr_en_i & ~full_r)) || 
                                              (~((wr_cmpaddr_r != rd_cmpaddr_r) || wr_en_i) & empty_r);

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
            full_mem_r      <= 1'b0;
            empty_ext_r     <= 1'b1;
            empty_r         <= 1'b1;
            empty_mem_r     <= 1'b1;
    
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
            full_mem_r      <= full_nxt_w;
            empty_ext_r     <= empty_nxt_w;
            empty_r         <= empty_nxt_w;
            empty_mem_r     <= empty_nxt_w;
    
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
            full_mem_r      <= 1'b0;
            empty_ext_r     <= 1'b1;
            empty_r         <= 1'b1;
            empty_mem_r     <= 1'b1;
    
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
            full_mem_r      <= full_nxt_w;
            empty_ext_r     <= empty_nxt_w;
            empty_r         <= empty_nxt_w;
            empty_mem_r     <= empty_nxt_w;
    
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
    reg full_flag_r   /*synthesis syn_preserve=1*/;
    reg empty_flag_r  /*synthesis syn_preserve=1*/;
    reg [ADDRESS_WIDTH:0] wr_flag_addr_r    /*synthesis syn_preserve=1*/;
    reg [ADDRESS_WIDTH:0] wr_flag_addr_p1_r /*synthesis syn_preserve=1*/;
    reg [ADDRESS_WIDTH:0] rd_flag_addr_r    /*synthesis syn_preserve=1*/;
    reg [ADDRESS_WIDTH:0] rd_flag_addr_p1_r /*synthesis syn_preserve=1*/;
    
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

// -----------------
// -- FIFO MEMORY --
// -----------------

wire wr_fifo_en_w = wr_en_i & ~full_mem_r;
wire rd_fifo_en_w = rd_en_i & ~empty_mem_r;

if(IMPLEMENTATION == "EBR") begin : mem_EBR
    reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0] /* synthesis syn_ramstyle="block_ram" */;
    reg [DATA_WIDTH-1:0] data_raw_r;
    reg [DATA_WIDTH-1:0] data_buff_r;

    // synthesis translate_off
    integer i0;
    initial begin
        for(i0 = 0; i0 < 2**ADDRESS_WIDTH; i0 = i0 + 1) begin
            mem[i0] = {DATA_WIDTH{1'b0}};
        end
    end
    // synthesis translate_on
    assign rd_data_o = (REGMODE == "reg") ? data_buff_r : data_raw_r;
    
    always @ (posedge clk_i) begin
        if(wr_fifo_en_w == 1'b1) begin
            mem[waddr_r] <= wr_data_i;
        end
    end
    
    always @ (posedge clk_i) begin
        if(rd_fifo_en_w == 1'b1) begin
            data_raw_r <= mem[raddr_r];
        end
    end
    if(REGMODE == "reg") begin : mem_reg
        if(RESET_MODE == "sync") begin : sync
            always @ (posedge clk_i) begin
                if(rst_i == 1'b1) begin
                    data_buff_r <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    data_buff_r <= data_raw_r;
                end
            end
        end // end sync
        else begin : async
            always @ (posedge clk_i, posedge rst_i) begin
                if(rst_i == 1'b1) begin
                    data_buff_r <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    data_buff_r <= data_raw_r;
                end
            end
        end // end async
    end // end mem_reg
end // end mem_EBR
else if (FAMILY == "LIFCL") begin : mem_LUT
    reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0] /* synthesis syn_ramstyle="distributed" */;
    reg [DATA_WIDTH-1:0] data_raw_r = {DATA_WIDTH{1'b0}};
    reg [DATA_WIDTH-1:0] data_buff_r = {DATA_WIDTH{1'b0}}; 
    assign rd_data_o = (REGMODE == "reg") ? data_buff_r : data_raw_r;

    // synthesis translate_off
    integer i0;
    initial begin
        for(i0 = 0; i0 < 2**ADDRESS_WIDTH; i0 = i0 + 1) begin
            mem[i0] = {DATA_WIDTH{1'b0}};
        end
    end
    // synthesis translate_on

    always @ (posedge clk_i) begin
        if(wr_fifo_en_w == 1'b1) begin
            mem[waddr_r] <= wr_data_i;
        end
    end
    
    always @ (posedge clk_i) begin
        if(rd_fifo_en_w == 1'b1) begin
            data_raw_r <= mem[raddr_r];
        end
    end

    if(REGMODE == "reg") begin : mem_reg
        if(RESET_MODE == "sync") begin : sync
            always @ (posedge clk_i) begin
                if(rst_i == 1'b1) begin
                    data_buff_r <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    data_buff_r <= data_raw_r;
                end
            end
        end // end sync
        else begin : async
            always @ (posedge clk_i, posedge rst_i) begin
                if(rst_i == 1'b1) begin
                    data_buff_r <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    data_buff_r <= data_raw_r;
                end
            end
        end // end async
    end // end mem_reg
end // mem_LUT
else begin : mem_REG
    reg [DATA_WIDTH-1:0] mem [2**ADDRESS_WIDTH-1:0] /* synthesis syn_ramstyle="registers" */;
    reg [DATA_WIDTH-1:0] data_raw_r = {DATA_WIDTH{1'b0}};
    reg [DATA_WIDTH-1:0] data_buff_r = {DATA_WIDTH{1'b0}}; 
    assign rd_data_o = (REGMODE == "reg") ? data_buff_r : data_raw_r;

    // synthesis translate_off
    integer i0;
    initial begin
        for(i0 = 0; i0 < 2**ADDRESS_WIDTH; i0 = i0 + 1) begin
            mem[i0] = {DATA_WIDTH{1'b0}};
        end
    end
    // synthesis translate_on

    always @ (posedge clk_i) begin
        if(wr_fifo_en_w == 1'b1) begin
            mem[waddr_r] <= wr_data_i;
        end
    end
    
    always @ (posedge clk_i) begin
        if(rd_fifo_en_w == 1'b1) begin
            data_raw_r <= mem[raddr_r];
        end
    end

    if(REGMODE == "reg") begin : mem_reg
        if(RESET_MODE == "sync") begin : sync
            always @ (posedge clk_i) begin
                if(rst_i == 1'b1) begin
                    data_buff_r <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    data_buff_r <= data_raw_r;
                end
            end
        end // end sync
        else begin : async
            always @ (posedge clk_i, posedge rst_i) begin
                if(rst_i == 1'b1) begin
                    data_buff_r <= {DATA_WIDTH{1'b0}};
                end
                else begin
                    data_buff_r <= data_raw_r;
                end
            end
        end // end async
    end // end mem_reg
end // mem_REG

//------------------------------------------------------------------------------
// Function Definition
//------------------------------------------------------------------------------

function [31:0] clog2;
  input [31:0] value;
  reg   [31:0] num;
  begin
    num = value - 1;
    for (clog2=0; num>0; clog2=clog2+1) num = num>>1;
  end
endfunction

endmodule
`endif