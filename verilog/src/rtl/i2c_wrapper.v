`timescale 1ns / 1ps

module i2c_wrapper #
(
    parameter FILTER_LEN = 4,
    parameter DATA_WIDTH = 32,  // width of data bus in bits
    parameter ADDR_WIDTH = 16,  // width of address bus in bits
    parameter STRB_WIDTH = (DATA_WIDTH/8)
)
(
    input wire                    clk,
    input wire                    rst,

    /*
     * I2C interface
     */
    input  wire                   i2c_scl_i,
    output wire                   i2c_scl_o,
    output wire                   i2c_scl_t,
    input  wire                   i2c_sda_i,
    output wire                   i2c_sda_o,
    output wire                   i2c_sda_t,

    /*
     * AXI lite master interface
     */
    output reg  [ADDR_WIDTH-1:0]  m_axil_awaddr,
    output wire [2:0]             m_axil_awprot,
    output reg                    m_axil_awvalid,
    input  wire                   m_axil_awready,
    output reg  [DATA_WIDTH-1:0]  m_axil_wdata,
    output wire [STRB_WIDTH-1:0]  m_axil_wstrb,
    output reg                    m_axil_wvalid,
    input  wire                   m_axil_wready,
    input  wire [1:0]             m_axil_bresp,
    input  wire                   m_axil_bvalid,
    output wire                   m_axil_bready,
    output reg  [ADDR_WIDTH-1:0]  m_axil_araddr,
    output wire [2:0]             m_axil_arprot,
    output reg                    m_axil_arvalid,
    input  wire                   m_axil_arready,
    input  wire [DATA_WIDTH-1:0]  m_axil_rdata,
    input  wire [1:0]             m_axil_rresp,
    input  wire                   m_axil_rvalid,
    output wire                   m_axil_rready,

    /*
     * Status
     */
    output wire                   busy,
    output wire                   bus_addressed,
    output wire                   bus_active,

    /*
     * Configuration
     */
    input  wire                   enable,
    input  wire [6:0]             device_address
);

    wire m_axil_awvalid_int;
    wire m_axil_wvalid_int;
    wire m_axil_arvalid_int;
    wire [ADDR_WIDTH - 1 : 0] m_axil_awaddr_int;
    wire [DATA_WIDTH - 1 : 0] m_axil_wdata_int;
    wire [ADDR_WIDTH - 1 : 0] m_axil_araddr_int;

    always @(posedge clk or negedge rst) begin
        if (rst == 1'b1) begin
            m_axil_awvalid <= 1'b0;
            m_axil_wvalid  <= 1'b0;
            m_axil_arvalid <= 1'b0;
        end else begin
            if (m_axil_awready == 1'b1 & m_axil_awvalid == 1'b1) begin
                m_axil_awvalid <= 1'b0;
            end else if (m_axil_awvalid_int == 1'b1) begin
                m_axil_awaddr <= m_axil_awaddr_int;
                m_axil_awvalid <= 1'b1;
            end
            if (m_axil_wready == 1'b1 && m_axil_wvalid == 1'b1) begin
                m_axil_wvalid <= 1'b0;
            end else if (m_axil_wvalid_int == 1'b1) begin
                m_axil_wdata <= m_axil_wdata_int;
                m_axil_wvalid <= 1'b1;
            end
            if (m_axil_arready == 1'b1 && m_axil_arvalid == 1'b1) begin
                m_axil_arvalid <= 1'b0;
            end else if (m_axil_arvalid_int == 1'b1) begin
                m_axil_araddr <= m_axil_araddr_int;
                m_axil_arvalid <= 1'b1;
            end
        end
    end


    `ifndef SIMULATION
    i2c_slave_axil_master  #(
        .FILTER_LEN(FILTER_LEN),
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .STRB_WIDTH(STRB_WIDTH)
    ) i2c_slave_axil_master_inst (
        .clk(clk),
        .rst(rst),

        /*
        * I2C interface
        */
        .i2c_scl_i(i2c_scl_i),
        .i2c_scl_o(i2c_scl_o),
        .i2c_scl_t(i2c_scl_t),
        .i2c_sda_i(i2c_sda_i),
        .i2c_sda_o(i2c_sda_o),
        .i2c_sda_t(i2c_sda_t),

        /*
        * AXI lite master interface
        */
        .m_axil_awaddr  (m_axil_awaddr_int),
        // .m_axil_awprot  (m_axil_awprot),
        .m_axil_awvalid (m_axil_awvalid_int),
        .m_axil_awready (m_axil_awready),
        .m_axil_wdata   (m_axil_wdata_int),
        // .m_axil_wstrb   (m_axil_wstrb),
        .m_axil_wvalid  (m_axil_wvalid_int),
        .m_axil_wready  (m_axil_wready),
        .m_axil_bresp   (0),
        // .m_axil_bvalid  (m_axil_bvalid),
        .m_axil_bvalid  (m_axil_bready),
        .m_axil_bready  (m_axil_bready),
        .m_axil_araddr  (m_axil_araddr_int),
        // .m_axil_arprot  (m_axil_arprot),
        .m_axil_arvalid (m_axil_arvalid_int),
        .m_axil_arready (m_axil_arready),
        .m_axil_rdata   (m_axil_rdata),
        // .m_axil_rresp   (m_axil_rresp),
        .m_axil_rresp   (0),
        .m_axil_rvalid  (m_axil_rvalid),
        .m_axil_rready  (m_axil_rready),

        /*
        * Status
        */
        .busy           (busy),
        .bus_addressed  (bus_addressed),
        .bus_active     (bus_active),

        /*
        * Configuration
        */
        .enable         (enable),
        .device_address (device_address)
    );
    `endif


endmodule