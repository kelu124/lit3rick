module i2s_control #(
	parameter AUDIO_DW = 32
)(
    input clk,
    input reset,

    input i2s_clk,
    output reg i2s_tx_reset,
    
    input start,
    input i2s_channel,
    output reg [AUDIO_DW * 2 - 1 : 0] data_out,

    output wire [13:0] mem_addr,
    output reg fifo_rd,
    input [7:0] from_mem
);

    localparam p_head_size = 256;
    localparam p_data_size = 256;
    localparam bpw = AUDIO_DW * 2 / 8; // bytes per word

    reg [15:0] data_cnt;
    reg        data_cnt_ov;
    reg [8:0] head_cnt;
    reg [3:0] pack_cnt;
    reg i2s_channel_z;
    reg i2s_channel_zz;
    wire i2s_channel_posedge;
    wire i2s_channel_negedge;
    wire tran_head;
    wire [7:0] new_byte;
    wire start_int;
    wire data_we;
    wire data_we_int;
    reg data_we_int_z;
    reg data_we_int_zz;

    reg [7:0] header_data [p_head_size - 1:0];

    initial begin : mem_init
        integer i;

        for (i = 0; i < p_head_size; i = i + 1) begin
            // if ((i >> 2) & 1)
            //     header_data[i] <= 8'h11;
            // else
            //     header_data[i] <= 8'h10;
            header_data[i] <= i;
        end
    end

    assign start_int = (start == 1) || data_cnt_ov;
    assign i2s_channel_posedge = i2s_channel_z && !i2s_channel_zz;
    assign i2s_channel_negedge = !i2s_channel_z && i2s_channel_zz;
    assign tran_head = (head_cnt < p_head_size) ? 1 : 0;
    assign new_byte = (tran_head == 1) ? header_data[head_cnt + pack_cnt] : from_mem;
    assign mem_addr = data_cnt + pack_cnt;
    assign data_we_int = (pack_cnt < bpw) ? !i2s_channel : 0;
    // assign fifo_rd = data_we_int && !tran_head && !start_int;
    assign data_we = (tran_head == 1) ? data_we_int : data_we_int_z;

    always @(posedge clk) begin
        fifo_rd <= data_we_int && !tran_head && !start_int;
    end

    always @(posedge clk) begin
        data_we_int_zz <= data_we_int_z;
        data_we_int_z <= data_we_int;

        if (i2s_channel_negedge == 1 || start_int == 1) begin
            pack_cnt <= 0;
        end else if (pack_cnt < bpw) begin
            pack_cnt <= pack_cnt + 1;
        end
        if (data_we == 1) begin
            data_out <= {new_byte, data_out[AUDIO_DW * 2 - 1 : 8]};
        end
    end



    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            data_cnt <= 0;
            head_cnt <= 0;
            i2s_channel_zz <= 0;
            i2s_channel_z <= 0;
            data_cnt_ov <= 0;
        end else begin
            data_cnt_ov <= (data_cnt == (p_data_size - 2)) ? 1'b1 : 1'b0;
            i2s_channel_zz <= i2s_channel_z;
            i2s_channel_z <= i2s_channel;
            if (start_int == 1) begin
                data_cnt <= 0;
                head_cnt <= 0;
            end else begin
                if (i2s_channel_negedge == 1 && tran_head == 1) begin
                    head_cnt <= head_cnt + (AUDIO_DW * 2 / 8);
                end else if (i2s_channel_negedge == 1) begin
                    data_cnt <= data_cnt + (AUDIO_DW * 2 / 8);
                end
            end
        end
    end

endmodule