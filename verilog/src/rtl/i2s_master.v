module i2s_tx #(
	parameter AUDIO_DW	= 32
)(
	input			sclk,
	input			rst,

	// Prescaler for lrclk generation from sclk should hold the number of
	// sclk cycles per channel (left and right).
	input [AUDIO_DW-1:0]	prescaler,

	output reg		lrclk = 0,
	output reg		sdata,

	// Parallel datastreams
	input [AUDIO_DW-1:0]	left_chan,
	input [AUDIO_DW-1:0]	right_chan
);

reg [AUDIO_DW-1:0]		bit_cnt = 0;
reg [AUDIO_DW-1:0]		left = 0;
reg [AUDIO_DW-1:0]		right = 1;

always @(posedge sclk) begin
	if (rst)
		bit_cnt <= 1;
	else if (bit_cnt >= prescaler)
		bit_cnt <= 1;
	else
		bit_cnt <= bit_cnt + 1;
end

// Sample channels on the transfer of the last bit of the right channel
always @(posedge sclk) begin
	// if (bit_cnt == prescaler && ~lrclk) begin
	// 	left <= left + 8'h2;
	// 	right <= right + 8'h2;
	// end
	if (bit_cnt == prescaler && lrclk) begin
		left <= left_chan;
		right <= right_chan;
	end
end

// left/right "clock" generation - 0 = left, 1 = right
always @(posedge sclk) begin
	if (rst)
		lrclk <= 1;
	else if (bit_cnt == prescaler)
		lrclk <= ~lrclk;
end

always @(posedge sclk) begin
	sdata <= lrclk ? right[AUDIO_DW - bit_cnt] : left[AUDIO_DW - bit_cnt];
	// sdata <= left[AUDIO_DW - bit_cnt];
end

endmodule