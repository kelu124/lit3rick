//==============================================================================
// A-Law coder (compressor)
//
// Based on alaw_compress() function in file Software/stl2009/g711/g711.c
// G.191 : Software tools for speech and audio coding standardization
// https://www.itu.int/rec/T-REC-G.191-201901-I/en
//
// First difference - sign bit is removed and mantissa is expanded up to 5 bits.
// Second difference - XOR 0x55 is not applied to the output data.
// Example of 15 bits to 8 bits compression:
// 0000000abcdexxx    000abcde
// 0000001abcdexxx    001abcde
// 000001abcdexxxx    010abcde
// 00001abcdexxxxx    011abcde
// 0001abcdexxxxxx    100abcde
// 001abcdexxxxxxx    101abcde
// 01abcdexxxxxxxx    110abcde
// 1abcdexxxxxxxxx    111abcde
//
//=============================================================================
module alaw_coder
#(
    parameter DATA_IN_W  = 15, // Data input width
    parameter DATA_OUT_W = 8   // Data output width
)
(
    // System
    input wire                  clk,        // System clock
    input wire                  rst,        // System reset
    // Input data
    input  wire [DATA_IN_W-1:0] data_in,    // Data input
    input  wire                 valid_in,   // Data input is valid
    // Output data
    output reg [DATA_OUT_W-1:0] data_out,   // Data output
    output reg                  valid_out   // Output data is valid
);

//-----------------------------------------------------------------------------
// Local parameters
//-----------------------------------------------------------------------------
localparam EXP_W = 3;
localparam MANT_W = DATA_OUT_W - EXP_W;

//-----------------------------------------------------------------------------
// Local variables
//-----------------------------------------------------------------------------
reg                   pre_valid_out;
reg  [DATA_IN_W-1:0]  data_shifter;
reg  [EXP_W-1:0]      shift_cnt;
reg                   busy;
wire                  done;

//-----------------------------------------------------------------------------
// Coder
//-----------------------------------------------------------------------------
assign done = data_shifter[DATA_IN_W-1] || (shift_cnt == 0);

always @(posedge clk or posedge rst)
begin
    if (rst)
        busy <= 1'b0;
    else if (!busy && valid_in && (!data_in[DATA_IN_W-1]))
        busy <= 1'b1;
    else if (busy && done)
        busy <= 1'b0;
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        data_shifter <= 0;
    else if (busy && (shift_cnt > 1) && !done)
        data_shifter <= {data_shifter[DATA_IN_W-2:0], 1'b0};
    else if (valid_in)
        data_shifter <= data_in;
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        shift_cnt <= {EXP_W{1'b1}};
    else if (busy && !done)
        shift_cnt <= shift_cnt - 1;
    else if (pre_valid_out)
        shift_cnt <= {EXP_W{1'b1}};
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        data_out <= 0;
    else if (pre_valid_out)
        data_out = {shift_cnt, data_shifter[DATA_IN_W-2-:MANT_W]};
end

//-----------------------------------------------------------------------------
// Output valid
//-----------------------------------------------------------------------------
always @(posedge clk or posedge rst)
begin
    if (rst)
        pre_valid_out <= 1'b0;
    else if (busy && done)
        pre_valid_out <= 1'b1;
    else if (valid_in && data_in[DATA_IN_W-1])
        pre_valid_out <= 1'b1;
    else
        pre_valid_out <= 1'b0;
end

always @(posedge clk or posedge rst)
begin
    if (rst)
        valid_out <= 1'b0;
    else
        valid_out <= pre_valid_out;
end

endmodule