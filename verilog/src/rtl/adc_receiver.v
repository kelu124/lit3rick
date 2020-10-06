//  Module: adc_receiver
//
module adc_receiver (
        input                clk,
        input                reset,
        input                start,
        input       [11 : 0] ADC_D,
        output reg  [11 : 0] DOUT,
        output reg           DOUT_vld,
        output reg  [15 : 0] sample_num,
        output reg           finish
    );

    reg         start_z;
    reg         start_zz;
    reg [15:0]  adc_recv_cnt;
    reg [11:0]  tmp;
    reg         adc_receiving;
    wire        adc_recv_cnt_ov;

    // assign DOUT = ADC_D;
    // assign DOUT_vld = adc_receiving;
    // assign sample_num = adc_recv_cnt;
    assign adc_recv_cnt_ov = (adc_recv_cnt == 8191) ? 1'b1 : 1'b0;

    always @(posedge clk or posedge reset) begin
        if (reset == 1) begin
            adc_receiving   <= 0;
            start_z         <= 0;
            start_zz        <= 0;
            finish          <= 0;
            DOUT_vld        <= 0;
        end else begin
            start_zz <= start_z;
            start_z <= start;
            tmp <= ADC_D;
            DOUT_vld <= adc_receiving;
            DOUT <= $signed({0, tmp}) - $signed(2048);
            sample_num <= adc_recv_cnt;
            // DOUT <= {4'b0000, ADC_D[11:4]};
            finish <= adc_recv_cnt_ov;
            
            if (adc_recv_cnt_ov == 1) begin
                adc_receiving   <= 0;
                adc_recv_cnt    <= 0;
            end else if (adc_receiving == 0 && start_z == 1 && start_zz == 0) begin
                adc_receiving   <= 1;
                adc_recv_cnt    <= 0;
            end else if (adc_receiving == 1) begin
                adc_recv_cnt    <= adc_recv_cnt + 1;
            end

        end
    end
    
endmodule
