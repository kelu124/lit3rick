interface ad9629_if;
    logic ADC_REF_CLK;
    logic ADC_DCLK;
    logic [11:0] ADC_D = 0;

    task send_data(bit [11:0] data []);
        integer i;

        for(i = 0; i < data.size; i += 1) begin
            @(posedge ADC_DCLK);
            ADC_D = data[i];
        end
    endtask
endinterface