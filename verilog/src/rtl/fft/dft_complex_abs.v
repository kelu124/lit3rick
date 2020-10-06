//==============================================================================
// DFT Complex Abs() function
//
// Calculates
//   result = sqrt(a.re^2 + a.im^2)
//
//=============================================================================
module dft_complex_abs
#(
    parameter DATA_W = 16
)
(
    // System
    input wire                      clk,        // System clock
    input wire                      rst,        // System reset
    // Input data
    input  wire signed [DATA_W-1:0] data_re,    // Data real part
    input  wire signed [DATA_W-1:0] data_im,    // Data imaginary part
    input  wire                     valid,      // Data valid
    // Output data
    output wire        [DATA_W-1:0] result,     // Result
    output wire                     done        // Calculations were done
);

//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam SQRSUM_W = 2*DATA_W;
localparam SQRT_W   = SQRSUM_W;

localparam FIFO_ADDR_W = 2;
localparam FIFO_DATA_W = SQRSUM_W;

localparam SQRSUM_PIPELINE_STAGES = 2;
localparam SQRT_PIPELINE_STAGES = 1;

localparam WAIT_FIFO_NON_EMPTY_S = 2'd0;
localparam READ_FIFO_S           = 2'd1;
localparam WAIT_SQRT_S           = 2'd2;

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
reg [1:0] fsm_state;
reg [1:0] fsm_next;
wire [SQRSUM_W-1:0] sqrsum_res;
wire                sqrsum_valid;

wire [SQRT_W-1:0] sqrt_data;
wire              sqrt_valid;

wire fifo_empty;
reg  fifo_rd;

//-----------------------------------------------------------------------------
// re^2 + im^2
//-----------------------------------------------------------------------------
dft_sqrsum
#(
    .DATA_W              (DATA_W),
    .SUM_PIPELINE_STAGES (SQRSUM_PIPELINE_STAGES)
) sqrsum (
    // System
    .clk        (clk),     // System clock
    .rst        (rst),     // System reset
    // Input data
    .data_re    (data_re), // Data real part
    .data_im    (data_im), // Data imaginary part
    // Output data
    .result     (sqrsum_res)   // Result
);

dft_dline
#(
    .STAGES_N (SQRSUM_PIPELINE_STAGES + 3) // input reg + 2 for squares + sum output reg
) sqrsum_valid_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (valid),
    .dout   (sqrsum_valid)
);

//-----------------------------------------------------------------------------
// FIFO
//-----------------------------------------------------------------------------
dft_fifo
#(
    .ADDR_W (FIFO_ADDR_W),  // Memory depth
    .DATA_W (FIFO_DATA_W)   // Data width
) fifo (
    // System
    .clk    (clk),          // System clock
    .rst    (rst),          // System reset
    // Write interface
    .wdata  (sqrsum_res),   // Write data
    .wr     (sqrsum_valid), // Write operation
    .full   (),             // FIFO is full
    // Read interface
    .rdata  (sqrt_data),    // Read data
    .rd     (fifo_rd),      // Read operation
    .empty  (fifo_empty)    // FIFO is empty
);

// Read FIFO FSM
always @(posedge clk or posedge rst)
begin
    if (rst)
        fsm_state <= WAIT_FIFO_NON_EMPTY_S;
    else
        fsm_state <= fsm_next;
end

always @(*)
begin
    fsm_next = fsm_state;
    case (fsm_state)
        WAIT_FIFO_NON_EMPTY_S: begin
            if (!fifo_empty)
                fsm_next = READ_FIFO_S;
        end

        READ_FIFO_S: begin
            fsm_next = WAIT_SQRT_S;
        end

        WAIT_SQRT_S: begin
            if (!done)
                fsm_next = WAIT_SQRT_S;
            else if (!fifo_empty)
                fsm_next = READ_FIFO_S;
            else
                fsm_next = WAIT_FIFO_NON_EMPTY_S;

        end
    endcase
end

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        fifo_rd   <= 1'b0;
    end
    else begin
        case (fsm_state)
            WAIT_FIFO_NON_EMPTY_S : begin
                if (!fifo_empty)
                    fifo_rd <= 1'b1;
            end

            READ_FIFO_S : begin
                fifo_rd <= 1'b0;
            end

            WAIT_SQRT_S : begin
                if (!fifo_empty && done)
                    fifo_rd <= 1'b1;
            end
        endcase
    end
end


//-----------------------------------------------------------------------------
// Sqrt()
//-----------------------------------------------------------------------------
dft_dline
#(
    .STAGES_N (1)
) sqrt_valid_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (fifo_rd),
    .dout   (sqrt_valid)
);

dft_sqrt
#(
    .DATA_W (SQRT_W),
    .ALU_PIPELINE_STAGES (SQRT_PIPELINE_STAGES)
) sqrt (
    // System
    .clk    (clk),          // System clock
    .rst    (rst),          // System reset
    // Input data
    .data   (sqrt_data),    // Data input
    .valid  (sqrt_valid),   // Data valid
    // Output data
    .result (result),       // Result
    .done   (done)          // Calculations were done
);




endmodule