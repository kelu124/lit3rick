interface i2c;
    logic ref_clk;

    wire sda;
    wire scl;

    logic axi_clk;
    logic [15:0] awaddr = 0;
    logic awvalid = 1'b0;
    logic awready;
    logic [31:0] wdata = 0;
    logic wvalid = 1'b0;
    logic wready;
    logic [15:0] araddr = 0;
    logic arvalid = 1'b0;
    logic arready;
    logic [31:0] rdata;
    logic rvalid;
    logic rready = 1'b1;
    

    logic sda_int;
    logic scl_int;
    logic out = 0;

    assign sda = (out == 1) ? sda_int : 1'bz;
    assign scl = (out == 1) ? scl_int : 1'bz;

    task read(input bit[15:0] addr, inout bit[31:0] data);
        araddr = addr;
        arvalid = 1;
        rready = 1;
        @(posedge axi_clk iff arready == 1);
        arvalid = 0;
        @(posedge axi_clk iff rvalid == 1)
        data = rdata;
        arvalid = 0;
        rready = 0;
    endtask

    task write(input bit[15:0] addr, input bit [31:0] data);
        awaddr = addr;
        awvalid = 1;
        wdata = data;
        wvalid = 1;
        @(posedge axi_clk);
        awaddr = -1;
        awaddr = -1;
        awvalid = 0;
        wvalid = 0;
    endtask


    task write_rpi(input bit[6:0] dev_addr, input bit[15:0] addr, input bit[31:0] data);
        bit [62 : 0] tmp;
        out = 1;
        scl_int = 1;
        sda_int = 1;
        @(posedge ref_clk);
        sda_int = 0;
        tmp[62:54] = {dev_addr, 2'b0Z};
        tmp[53:36] = {addr[15:8], 1'bZ, addr[7:0], 1'bZ};
        tmp[35:0] = {data[31:24], 1'bZ, data[23:16], 1'bZ, data[15:8], 1'bZ, data[7:0], 1'bZ};
        for (int i = 0; i < 63; i += 1) begin
            @(negedge ref_clk);
            scl_int = 0;
            @(posedge ref_clk);
            sda_int = tmp[62 - i];
            @(negedge ref_clk);
            scl_int = 1;
        end
        @(negedge ref_clk);
        scl_int = 0;
        @(negedge ref_clk);
        scl_int = 1;
        @(posedge ref_clk);
        sda_int = 1;
        @(negedge ref_clk);
        out = 0;
        $display("written value %8h | into reg %0d", data, addr);
    endtask

    task read_rpi(input bit[6:0] dev_addr, input bit[15:0] addr, inout bit [31:0] data);
        bit [35 : 0] tmp;
        int i;

        // $display("at time %0t | Start reading from addr : %0d", $time, addr);

        out = 1;
        scl_int = 1;
        sda_int = 1;
        @(posedge ref_clk);
        sda_int = 0;
        tmp[35:27] = {dev_addr, 2'b0Z};
        tmp[26:9] = {addr[15:8], 1'bZ, addr[7:0], 1'bZ};
        tmp[8:0] = {dev_addr, 2'b1Z};
        // $display("tmp value : %0h", tmp);
        for (i = 0; i < 27; i += 1) begin
            @(negedge ref_clk);
            scl_int = 0;
            @(posedge ref_clk);
            sda_int = tmp[35 - i];
            @(negedge ref_clk);
            scl_int = 1;
        end
        @(negedge ref_clk);
        scl_int = 0;
        @(posedge ref_clk);
        sda_int = 1;
        @(negedge ref_clk);
        scl_int = 1;
        @(posedge ref_clk);
        sda_int = 0;
        for (i = 27; i < 36; i += 1) begin
            @(negedge ref_clk);
            scl_int = 0;
            @(posedge ref_clk);
            sda_int = tmp[35 - i];
            @(negedge ref_clk);
            scl_int = 1;
        end
        
        sda_int = 1'bZ;
        for (i = 0; i < 32; i += 1) begin
            @(negedge ref_clk);
            scl_int = 0;
            @(posedge ref_clk);
            data[31 - i] = sda;
            @(negedge ref_clk);
            scl_int = 1;
            if ((i + 1) % 8 == 0) begin
                @(negedge ref_clk);
                scl_int = 0;
                @(posedge ref_clk);
                sda_int = 1'b0;
                @(negedge ref_clk);
                scl_int = 1;
                @(negedge ref_clk);
                scl_int = 0;
                @(posedge ref_clk);
                sda_int = (i != 31) ? 1'bZ : 1'b0;
            end
        end
        @(negedge ref_clk);
        scl_int = 1;
        @(posedge ref_clk);
        // data = {data[7:0], data[15:8], data[23:16], data[31:24]};
        $display("at time %0t | Readed value = %8h | from reg %0d", $time, data, addr);
        out = 0;
    endtask
endinterface