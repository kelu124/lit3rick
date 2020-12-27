/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

module top (
    output SPI_FLASH_CS,
    output SPI_FLASH_SCLK,
    inout  SPI_FLASH_MISO,
    inout  SPI_FLASH_MOSI,

    output PCM_FS,  // fpga load ok
    output PCM_DIN, // cpu load ok

    // Terminal
    output SER_TX,
    input  SER_RX,

    // LED
    output LED_RED, LED_GREEN, LED_BLUE
);

/* ------------------------
       Clock generator
   ------------------------*/

    wire clk;
    wire resetn;
    reg reset = 1;
    reg [7:0] reset_cnt = 0;
    wire pixclk;

    (* ROUTE_THROUGH_FABRIC=1 *)
    SB_HFOSC #(.CLKHF_DIV("0b10")) hfosc_i (
        .CLKHFEN(1'b1),
        .CLKHFPU(1'b1),
        .CLKHF(clk)
    );

     // Generate reset
    always @(posedge clk) begin
        reset <= (reset_cnt == 50) ? 0 : 1;
    end

    always@(posedge clk) begin
        if (reset_cnt < 50) begin
            reset_cnt <= reset_cnt + 1;
        end
    end

    assign resetn = ~reset;

// for debug purposes
reg [23:0] fpga_ok_cnt;
reg fpga_ok;
always @(posedge clk) begin
    if (!resetn) begin
        fpga_ok_cnt <= 0;
        fpga_ok <= 0;
    end else if (fpga_ok_cnt == 11999999) begin
        fpga_ok_cnt <= 0;
        fpga_ok <= ~fpga_ok;
    end else
        fpga_ok_cnt <= fpga_ok_cnt + 1;
end

assign PCM_FS = fpga_ok;
assign PCM_DIN  = gpio[4];

/* ------------------------
       PicoSoC
   ------------------------*/

    wire flash_io0_oe, flash_io0_do, flash_io0_di;
    wire flash_io1_oe, flash_io1_do, flash_io1_di;
    wire flash_io2_oe, flash_io2_do, flash_io2_di;
    wire flash_io3_oe, flash_io3_do, flash_io3_di;

    SB_IO #(
        .PIN_TYPE(6'b 1010_01),
        .PULLUP(1'b 0)
    ) flash_io_buf [1:0] (
        .PACKAGE_PIN({SPI_FLASH_MOSI, SPI_FLASH_MISO}),
        .OUTPUT_ENABLE({flash_io1_oe, flash_io0_oe}),
        .D_OUT_0({flash_io1_do, flash_io0_do}),
        .D_IN_0({flash_io1_di, flash_io0_di})
    );

    assign flash_io2_di = 1'b0;
    assign flash_io3_di = 1'b0;

    wire        iomem_valid;
    reg         iomem_ready;
    wire [3:0]  iomem_wstrb;
    wire [31:0] iomem_addr;
    wire [31:0] iomem_wdata;
    reg  [31:0] iomem_rdata;

    reg [31:0] gpio;    
    reg [31:0] tone;

    assign LED_RED   = !gpio[0];
    assign LED_GREEN = !gpio[1];
    assign LED_BLUE  = !gpio[2];

    always @(posedge clk) begin
        if (!resetn) begin
            gpio <= 32'd0;
            tone <= 32'd0;
        end else begin
            iomem_ready <= 0;
            if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 03) begin
                iomem_ready <= 1;
                if (iomem_wstrb[0]) gpio[ 7: 0] <= iomem_wdata[ 7: 0];
                iomem_rdata <= { 26'd0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1 };
            end else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 04) begin
                iomem_ready <= 1;
                iomem_rdata <= 32'h 0000_0000;
            end else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 05) begin
                iomem_ready <= 1;
                iomem_rdata <= 32'h 0000_0000;
            end else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 06) begin
                iomem_ready <= 1;
                if (iomem_wstrb[0]) tone[ 7: 0] <= iomem_wdata[ 7: 0];
                if (iomem_wstrb[1]) tone[15: 8] <= iomem_wdata[15: 8];
                if (iomem_wstrb[2]) tone[23:16] <= iomem_wdata[23:16];
                if (iomem_wstrb[3]) tone[31:24] <= iomem_wdata[31:24];
                iomem_rdata <= 32'h 0000_0000;
            end
        end
    end

    picosoc soc (
        .clk          (clk         ),
        .resetn       (resetn      ),

        .ser_tx       (SER_TX      ),
        .ser_rx       (SER_RX      ),

        .flash_csb    (SPI_FLASH_CS),
        .flash_clk    (SPI_FLASH_SCLK),

        .flash_io0_oe (flash_io0_oe),
        .flash_io1_oe (flash_io1_oe),
        .flash_io2_oe (flash_io2_oe),
        .flash_io3_oe (flash_io3_oe),

        .flash_io0_do (flash_io0_do),
        .flash_io1_do (flash_io1_do),
        .flash_io2_do (flash_io2_do),
        .flash_io3_do (flash_io3_do),

        .flash_io0_di (flash_io0_di),
        .flash_io1_di (flash_io1_di),
        .flash_io2_di (flash_io2_di),
        .flash_io3_di (flash_io3_di),

        .irq_5        (1'b0        ),
        .irq_6        (1'b0        ),
        .irq_7        (1'b0        ),

        .iomem_valid  (iomem_valid ),
        .iomem_ready  (iomem_ready ),
        .iomem_wstrb  (iomem_wstrb ),
        .iomem_addr   (iomem_addr  ),
        .iomem_wdata  (iomem_wdata ),
        .iomem_rdata  (iomem_rdata )
    );

endmodule
