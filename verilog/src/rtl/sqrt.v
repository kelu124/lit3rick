/*
output: sqrt(x1^2 + x2^2)
zubarev.e.v@gmail.com
*/

/*
sqrt #(16) instance_name(clock_input, first_signed_input, second_signed_input, unsigned_output);
*/
module sqrt
    #(parameter DATA_IN_WIDTH = 16)
    (
    input   wire                                    clk,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x1,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x2,
    output  wire            [ DATA_IN_WIDTH-1:  0 ] y
    );

localparam DATA_WIDTH_SQUARING = (2*DATA_IN_WIDTH) - 1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x1_2 = x1*x1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x2_2 = x2*x2;

localparam DATA_WIDTH_SUM = DATA_WIDTH_SQUARING+1;
// wire    [ DATA_WIDTH_SUM-1 :  0 ] x = x1_2 + x2_2;
wire    [ DATA_WIDTH_SUM-1 :  0 ] x = x1;

assign y[DATA_IN_WIDTH-1] = x[(DATA_WIDTH_SUM-1)-:2] == 2'b00 ? 1'b0 : 1'b1;
genvar k;
generate
    for(k = DATA_IN_WIDTH-2; k >= 0; k = k - 1)
    begin: gen
        assign y[k] = x[(DATA_WIDTH_SUM-1)-:(2*(DATA_IN_WIDTH-k))] < 
        {y[DATA_IN_WIDTH-1:k+1],1'b1}*{y[DATA_IN_WIDTH-1:k+1],1'b1} ? 1'b0 : 1'b1;
    end
endgenerate

endmodule
