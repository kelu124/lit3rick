interface mcp_spi_if;
    bit sdi;
    bit sck;
    bit cs;

    task receive(inout bit [15:0] data);
        int i;

        @(negedge cs);
        
        for (i = 0; i < 16; i += 1) begin
            @(posedge sck);
            data[15 - i] = sdi;
        end

        @(posedge cs);
    endtask
endinterface