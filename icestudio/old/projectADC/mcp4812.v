module mcp4812(
    input clk, 
    input reset,

    input [15:0] data,
    input data_valid,
    output busy,

    output CSn,
    output SCK,
    output SDI,
    output LDACn
);

    localparam max_div_cnt = 10;

    reg data_valid_z;
    reg work;
    reg [3:0] state;
    wire end_work;
    reg [7:0] clk_div_cnt;
    wire clk_div_cnt_ov;
    reg [4:0] bit_cnt;
    reg sck_int;
    reg [15:0] shift_reg;

    assign end_work = (bit_cnt == 19) ? clk_div_cnt_ov : 0;
    assign clk_div_cnt_ov = (clk_div_cnt == max_div_cnt) ? 1 : 0;
    assign SCK      = sck_int && !CSn;
    assign CSn      = (bit_cnt < 16) ? ~work : 1;
    assign SDI      = shift_reg[15];
    assign LDACn    = (bit_cnt == 18) ? 0 : 1;
    assign busy     = work;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            work <= 0;
            data_valid_z <= 0;
            clk_div_cnt <= 0;
            bit_cnt <= 0;
            sck_int <= 0;
            work <= 0;
        end else begin
            data_valid_z <= data_valid;

            if (work == 0) begin
                sck_int <= 0;
            end else if (clk_div_cnt_ov == 1) begin
                sck_int <= ~sck_int;
            end

            if (end_work == 1) begin
                work <= 0;
            end else if (data_valid == 1 && data_valid_z == 0) begin
                work <= 1;
            end

            if (data_valid == 1 && data_valid_z == 0) begin
                shift_reg <= data;
                bit_cnt <= 0;
            end else if (clk_div_cnt_ov == 1 && sck_int == 1) begin
                shift_reg <= {shift_reg[14:0], 1'b0};
                bit_cnt <= bit_cnt + 1;
            end

            if (clk_div_cnt_ov == 1 || work == 0) begin
                clk_div_cnt <= 0;
            end else begin
                clk_div_cnt <= clk_div_cnt + 1;
            end
        end
    end


endmodule
