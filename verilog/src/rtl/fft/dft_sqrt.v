//==============================================================================
// DFT Sqrt() function
//
// Non-restoring square root algorithm implementation
//
// Calculates
//   result = floor(sqrt(d))
//
// Total delay = INPUT_REG + (ALU_PIPELINE_STAGES+1)*(DATA_W/2) + OUTPUT_REG
//
// References:
//   "An FPGA Implementation of a Fixed-Point Square Root Operation", Krerk Piromsopa, 2002
//    https://www.researchgate.net/publication/2532597_An_FPGA_Implementation_of_a_Fixed-Point_Square_Root_Operation
//
//=============================================================================
module dft_sqrt
#(
    parameter DATA_W              = 32,
    parameter ALU_PIPELINE_STAGES = 2   // 0 ... 3
)
(
    // System
    input  wire                clk,    // System clock
    input  wire                rst,    // System reset
    // Input data
    input  wire [DATA_W-1:0]   data,   // Data input
    input  wire                valid,  // Data valid
    // Output data
    output wire [DATA_W/2-1:0] result, // Result
    output reg                 done    // Calculations were done
);

//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam RADICAND_W  = DATA_W;
localparam SOLUTION_W  = RADICAND_W/2;
localparam REMAINDER_W = SOLUTION_W+2;
localparam ALU_W       = REMAINDER_W;

localparam CALC_CNT_W = $clog2(SOLUTION_W);
localparam ALU_DELAY = ALU_PIPELINE_STAGES; // Will need +1 for ALU output registers (if enabled)

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
reg [RADICAND_W-1:0]  radicand;
reg [SOLUTION_W-1:0]  solution;
reg [REMAINDER_W-1:0] remainder;

wire                 calc_end;
reg                  calc_busy;
wire                 calc_step;
reg [ALU_DELAY:0]    calc_step_delay;
reg [CALC_CNT_W-1:0] calc_cnt;

wire [ALU_W-1:0] alu_res;
wire [ALU_W-1:0] alu_arg0;
wire [ALU_W-1:0] alu_arg1;
wire             alu_addsub;

//-----------------------------------------------------------------------------
// Calculation control
//-----------------------------------------------------------------------------
assign calc_end = (calc_cnt == {CALC_CNT_W{1'b1}}) && calc_step;

always @(posedge clk or posedge rst)
begin
    if (rst)
        calc_step_delay <= 1;
    else if (calc_end)
        calc_step_delay <= 1;
    else if (calc_busy && (ALU_DELAY > 0))
        calc_step_delay <= {calc_step_delay[ALU_DELAY-1:0], calc_step_delay[ALU_DELAY]};
end
assign calc_step = calc_step_delay[ALU_DELAY];

always @(posedge clk or posedge rst)
begin
    if (rst)
        calc_busy <= 1'b0;
    else if (valid)
        calc_busy <= 1'b1;
    else if (calc_end)
        calc_busy <= 1'b0;
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        calc_cnt <= 0;
    else if (calc_end)
        calc_cnt <= 0;
    else if (calc_busy && calc_step)
        calc_cnt <= calc_cnt + 1;
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        done <= 1'b0;
    else
        done <= calc_end;
end

assign result = solution;

//-----------------------------------------------------------------------------
// Radicand control
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        radicand <= 0;
    else if (calc_busy && calc_step)
        radicand <= {radicand[(RADICAND_W-2)-1:0], 2'b00};
    else if (valid)
        radicand <= data;
end

//-----------------------------------------------------------------------------
// Solution control
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        solution <= 0;
    else if (calc_busy && calc_step)
        solution <= {solution[(SOLUTION_W-1)-1:0], ~alu_res[ALU_W-1]};
    else if (valid)
        solution <= 0;
end

//-----------------------------------------------------------------------------
// ALU
//-----------------------------------------------------------------------------
dft_addsub
#(
    .DATA_W          (ALU_W),
    .DATA_SIGNED     ("off"),  // "on" / "off"
    .OUTPUT_REG      ("off"),  // "on" / "off"
    .PIPELINE_STAGES (ALU_PIPELINE_STAGES)
) alu (
    // System
    .clk    (clk),      // System clock
    .rst    (rst),      // System reset
    // Control
    .addsub (alu_addsub), // Addition(1) / Subtraction(0) select
    // Input data
    .data_a (alu_arg1),   // Data A
    .data_b (alu_arg0),   // Data B
    // Output data
    .result (alu_res)    // Result
);

assign alu_addsub = remainder[REMAINDER_W-1];
assign alu_arg0 = {solution, remainder[REMAINDER_W-1], 1'b1};
assign alu_arg1 = {remainder[(REMAINDER_W-2)-1:0], radicand[RADICAND_W-1:RADICAND_W-2]};

//-----------------------------------------------------------------------------
// Remainder control
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        remainder <= 0;
    else if (calc_busy && calc_step)
        remainder <= alu_res;
    else if (valid)
        remainder <= 0;
end

endmodule