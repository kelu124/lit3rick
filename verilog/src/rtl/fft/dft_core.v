//==============================================================================
// DFT Core
//
// Performs frequency bins calculations
//
// Window DFT integer implementation.
// Based on SDFT (https://www.comm.utoronto.ca/~dimitris/ece431/slidingdft.pdf,
// https://www.dsprelated.com/showarticle/776.php),
// but windows are not overlapped.
//
//=============================================================================
module dft_core
#(
    parameter DATA_IN_W  = 12,  // Data input width
    parameter DFT_N      = 16,  // Number of points in DFT window
    parameter DATA_OUT_W = 16   // Data output width
)
(
    // System
    input wire                         clk,         // System clock
    input wire                         rst,         // System reset
    input wire                         sync,        // Sync core
    // Input data from FIFO
    input  wire signed [DATA_IN_W-1:0] fifo_rdata,  // FIFO data
    output reg                         fifo_rd,     // FIFO data read
    input  wire                        fifo_empty,  // FIFO is empty
    // Output data
    output wire signed [DATA_OUT_W-1:0] data_re_out, // Data real part output
    output wire signed [DATA_OUT_W-1:0] data_im_out, // Data imaginary part output
    output wire                         valid_out    // Output data is valid
);
//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam FREQ_BINS_USED = 3;

localparam FRAM_ADDR_W = 2;
localparam FRAM_DATA_W = DATA_OUT_W;

localparam TWROM_ADDR_W = 2;
localparam TWROM_DATA_W = 16;

localparam ADD_DATA_W    = DATA_OUT_W;
localparam ADD_PIPELINE_STAGES = 2;
localparam ADD_DELAY = ADD_PIPELINE_STAGES + 1;

localparam CMUL_DATA_W    = DATA_OUT_W;
localparam CMUL_TWIDDLE_W = TWROM_DATA_W;
localparam CMUL_PIPELINE_STAGES = 4;
localparam CMUL_DELAY = CMUL_PIPELINE_STAGES + 4;

localparam FIFO_WAIT_NON_EMPTY = 2'd0;
localparam FIFO_FRAM_READ0_S   = 2'd1;
localparam FIFO_FRAM_READ1_S   = 2'd2;


//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
reg [1:0] fsm_state;
reg [1:0] fsm_next;

wire  [FRAM_DATA_W-1:0] fram_wdata_re;
wire  [FRAM_DATA_W-1:0] fram_wdata_im;
reg  [FRAM_ADDR_W-1:0] fram_waddr;
wire                    fram_wr;
wire [FRAM_DATA_W-1:0] fram_rdata_re;
wire [FRAM_DATA_W-1:0] fram_rdata_im;
wire [FRAM_DATA_W-1:0] fram_rdata_im_del;
reg  [FRAM_ADDR_W-1:0] fram_raddr;
reg                    fram_rd;

wire [TWROM_DATA_W-1:0] twrom_rdata_re;
wire [TWROM_DATA_W-1:0] twrom_rdata_im;
wire [TWROM_ADDR_W-1:0] twrom_raddr;
wire                    twrom_rd;

wire signed [ADD_DATA_W-1:0] add_data_a;
wire signed [ADD_DATA_W-1:0] add_data_b;
wire signed [ADD_DATA_W-1:0] add_result;
wire add_valid;

wire signed [CMUL_DATA_W-1:0]    cmul_data_re;
wire signed [CMUL_DATA_W-1:0]    cmul_data_im;
wire signed [CMUL_TWIDDLE_W-1:0] cmul_twiddle_re;
wire signed [CMUL_TWIDDLE_W-1:0] cmul_twiddle_im;
wire                             cmul_valid;
wire signed [CMUL_DATA_W-1:0]   cmul_result_re;
wire signed [CMUL_DATA_W-1:0]   cmul_result_im;
wire                            cmul_done;

reg [$clog2(DFT_N):0] pts_cnt;
reg [$clog2(DFT_N):0] pts_cnt_out;

//-----------------------------------------------------------------------------
// Window points counter
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        pts_cnt <= 0;
    else if (sync)
        pts_cnt <= 0;
    else if (fifo_rd) begin
        if (pts_cnt == DFT_N)
            pts_cnt <= 1;
        else
            pts_cnt <= pts_cnt + 1;
    end
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        pts_cnt_out <= 0;
    else if (sync)
        pts_cnt_out <= 0;
    else if ((fram_waddr == (FREQ_BINS_USED-1)) && cmul_done)
        pts_cnt_out <= pts_cnt;
end

//-----------------------------------------------------------------------------
// Frequency bins RAM
//-----------------------------------------------------------------------------
dft_freq_ram
#(
    .ADDR_W (FRAM_ADDR_W),  // Memory depth
    .DATA_W (FRAM_DATA_W)   // Data width
) fram (
    // System
    .clk        (clk),              // System clock
    .rst        (rst),              // System reset
    // Write interface
    .wdata_re   (fram_wdata_re),    // Write data real part
    .wdata_im   (fram_wdata_im),    // Write data imaginary part
    .waddr      (fram_waddr),       // Write address
    .wr         (fram_wr),          // Write operation
    // Read interface
    .rdata_re   (fram_rdata_re),    // Read data real part
    .rdata_im   (fram_rdata_im),    // Read data imaginary part
    .raddr      (fram_raddr),       // Read address
    .rd         (fram_rd)           // Read operation
);

assign fram_wdata_re = cmul_result_re;
assign fram_wdata_im = cmul_result_im;
assign fram_wr       = cmul_done;

always @(posedge clk or posedge rst)
begin
    if (rst)
        fram_waddr <= 0;
    else if (fram_wr) begin
        if (fram_waddr == (FREQ_BINS_USED-1))
            fram_waddr <= 0;
        else
            fram_waddr <= fram_waddr + 1;
    end
end

assign data_re_out = (pts_cnt_out == DFT_N)? cmul_result_re : 0;
assign data_im_out = (pts_cnt_out == DFT_N)? cmul_result_im : 0;
assign valid_out   = (pts_cnt_out == DFT_N)? cmul_done : 0;

dft_dline
#(
    .STAGES_N (ADD_DELAY),
    .DATA_W   (FRAM_DATA_W)
) fram_rdata_im_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (fram_rdata_im),
    .dout   (fram_rdata_im_del)
);

//-----------------------------------------------------------------------------
// Twiddle factors ROM
//-----------------------------------------------------------------------------
dft_twiddle_rom
#(
    .ADDR_W      (TWROM_ADDR_W),
    .DATA_W      (TWROM_DATA_W)
) twrom (
    // System
    .clk        (clk),              // System clock
    .rst        (rst),              // System reset
    // Read interface
    .rdata_re   (twrom_rdata_re),   // Read data real part
    .rdata_im   (twrom_rdata_im),   // Read data imaginary part
    .raddr      (twrom_raddr),      // Read address
    .rd         (twrom_rd)          // Read enable
);

dft_dline
#(
    .STAGES_N (ADD_DELAY),
    .DATA_W   (TWROM_ADDR_W)
) twrom_raddr_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (fram_raddr),
    .dout   (twrom_raddr)
);

dft_dline
#(
    .STAGES_N (ADD_DELAY)
) twrom_rd_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (fram_rd),
    .dout   (twrom_rd)
);

//-----------------------------------------------------------------------------
// Real part adder
//-----------------------------------------------------------------------------
dft_add
#(
    .DATA_W          (ADD_DATA_W),
    .DATA_SIGNED     ("off"),  // "on" / "off"
    .INPUT_REG       ("off"),  // "on" / "off"
    .OUTPUT_REG      ("on"),   // "on" / "off"
    .PIPELINE_STAGES (ADD_PIPELINE_STAGES),
    .PIPE_4BIT       (1'b1)
) add (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Input data
    .data_a (add_data_a),   // Data A
    .data_b (add_data_b),   // Data B
    // Output data
    .result (add_result)    // Result
);

assign add_data_a = {{ADD_DATA_W-DATA_IN_W{fifo_rdata[DATA_IN_W-1]}},fifo_rdata};
assign add_data_b = (pts_cnt <= 1) ? 0 : fram_rdata_re;

dft_dline
#(
    .STAGES_N (1)
) add_valid_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (twrom_rd),
    .dout   (add_valid)
);

//-----------------------------------------------------------------------------
// Complex multiplier
//-----------------------------------------------------------------------------
dft_complex_mul
#(
    .DATA_A_W        (CMUL_DATA_W),
    .DATA_B_W        (CMUL_TWIDDLE_W),
    .PIPELINE_STAGES (CMUL_PIPELINE_STAGES)
) cmul (
    // System
    .clk        (clk),              // System clock
    .rst        (rst),              // System reset
    // Input data
    .data_a_re (cmul_data_re),     // Data real part
    .data_a_im (cmul_data_im),     // Data imaginary part
    .data_b_re (cmul_twiddle_re),  // Twiddle factor real part
    .data_b_im (cmul_twiddle_im),   // Twiddle factor imaginary part
    // Output data
    .result_re  (cmul_result_re),   // Result real part
    .result_im  (cmul_result_im)    // Result imaginary part
);

assign cmul_twiddle_re = twrom_rdata_re;
assign cmul_twiddle_im = twrom_rdata_im;

assign cmul_data_re = add_result;
assign cmul_data_im = (pts_cnt <= 1) ? 0 : fram_rdata_im_del;

assign cmul_valid = add_valid;

dft_dline
#(
    .STAGES_N (CMUL_DELAY)
) cmul_done_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (cmul_valid),
    .dout   (cmul_done)
);

//-----------------------------------------------------------------------------
// FIFO and frequency bins RAM read FSM
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        fsm_state <= FIFO_WAIT_NON_EMPTY;
    else
        fsm_state <= fsm_next;
end

always @(*)
begin
    fsm_next = fsm_state;
    case (fsm_state)
        FIFO_WAIT_NON_EMPTY : begin
            if (!fifo_empty)
                fsm_next = FIFO_FRAM_READ1_S;
        end

        FIFO_FRAM_READ0_S : begin
            if (fifo_empty)
                fsm_next = FIFO_WAIT_NON_EMPTY;
            else if (cmul_done)
                fsm_next = FIFO_FRAM_READ1_S;
        end

        FIFO_FRAM_READ1_S : begin
            if (fram_raddr == (FREQ_BINS_USED-1))
                fsm_next = FIFO_FRAM_READ0_S;
            else
                fsm_next = FIFO_FRAM_READ1_S;
        end
    endcase
end

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        fifo_rd    <= 1'b0;
        fram_rd    <= 1'b0;
        fram_raddr <= 0;
    end
    else begin
        case (fsm_state)
            FIFO_WAIT_NON_EMPTY : begin
                if (!fifo_empty) begin
                    fifo_rd <= 1'b1;
                    fram_rd <= 1'b1;
                end
            end

            FIFO_FRAM_READ0_S : begin
                if (cmul_done) begin
                    fifo_rd <= 1'b1;
                    fram_rd <= 1'b1;
                end
            end

            FIFO_FRAM_READ1_S : begin
                fifo_rd <= 1'b0;
                if (fram_raddr == (FREQ_BINS_USED-1)) begin
                    fram_raddr <= 0;
                    fram_rd <= 1'b0;
                end else begin
                    fram_rd <= 1'b1;
                    fram_raddr <= fram_raddr + 1;
                end
            end
        endcase
    end
end


endmodule