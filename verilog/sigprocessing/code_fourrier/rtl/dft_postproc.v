//==============================================================================
// DFT Postprocessing Unit
//
// Performs calculation of
//   (abs(F1) + abs(F2) + abs(F3)) / (DFN_N / 2)
// where
//   abs = sqrt(Fn.re * Fn.re + Fn.im * Fn.im)
//   DFT_N - number of points in the DFT window
//
//=============================================================================
module dft_postproc
#(
    parameter DATA_W = 16 // Data width
)
(
    // System
    input wire                      clk,       // System clock
    input wire                      rst,       // System reset
    // Input data from FIFO
    input  wire signed [DATA_W-1:0] data_re_in,  // Data real part
    input  wire signed [DATA_W-1:0] data_im_in,  // Data imaginary part
    input  wire                     valid_in,    // Data is valid
    // Output data
    output wire        [DATA_W-2:0] data_out,    // Data output
    output reg                      valid_out    // Data output is valid
);
//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam AVG_POINTS = 3;
localparam AVG_W = DATA_W + AVG_POINTS-1;

localparam ADD_PIPELINE_STAGES = 2;
localparam ADD_DELAY = ADD_PIPELINE_STAGES + 1;

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
wire        [DATA_W-1:0] abs_result;
wire                     abs_done;

reg [AVG_W-1:0] avg;
wire [AVG_W-1:0] add_data_a;
wire [AVG_W-1:0] add_data_b;
wire [AVG_W-1:0] add_result;
wire add_valid;

reg [$clog2(AVG_POINTS)-1:0] avg_cnt;
wire avg_done;


//-----------------------------------------------------------------------------
// abs()
//-----------------------------------------------------------------------------
dft_complex_abs
#(
    .DATA_W (DATA_W)
)
abs
(
    // System
    .clk        (clk),      // System clock
    .rst        (rst),      // System reset
    // Input data
    .data_re    (data_re_in),  // Data real part
    .data_im    (data_im_in),  // Data imaginary part
    .valid      (valid_in),    // Data valid
    // Output data
    .result     (abs_result),   // Result
    .done       (abs_done)      // Calculations were done
);

//-----------------------------------------------------------------------------
// Average logic
//-----------------------------------------------------------------------------
dft_add
#(
    .DATA_W          (AVG_W),
    .DATA_SIGNED     ("off"),  // "on" / "off"
    .INPUT_REG       ("on"),  // "on" / "off"
    .OUTPUT_REG      ("off"),   // "on" / "off"
    .PIPELINE_STAGES (ADD_PIPELINE_STAGES)
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

assign add_data_a = avg;
assign add_data_b = abs_result;

dft_dline
#(
    .STAGES_N (ADD_DELAY)
) add_valid_dline (
    .clk    (clk),
    .rst    (rst),
    .din    (abs_done),
    .dout   (add_valid)
);

assign avg_done = avg_cnt == (AVG_POINTS-1);
always @(posedge clk or posedge rst)
begin
    if (rst)
        avg_cnt <= 0;
    else if (add_valid) begin
        if (avg_done)
            avg_cnt <= 0;
        else
            avg_cnt <= avg_cnt + 1;
    end
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        avg <= 0;
    else if (add_valid)
        avg <= add_result;
    else if (valid_out)
        avg <= 0;
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        valid_out <= 1'b0;
    else if (add_valid && avg_done)
        valid_out <= 1'b1;
    else
        valid_out <= 1'b0;
end

// Vector part select instead of shift
assign data_out = avg[AVG_W-1:3];

endmodule
