module ram_256k(
    input [13:0]  AD,
    input [15:0]  DI,
    input [3:0]   MASKWE,
    input         WE,
    input         CS,
    input         CK,
    input         STDBY,
    input         SLEEP,
    input         PWROFF_N,
    output [15:0] DO
);

`ifndef SIMULATION
    SP256K SP256K_inst (
        .AD       (AD),  // I
        .DI       (DI),  // I
        .MASKWE   (MASKWE),  // I
        .WE       (WE),  // I
        .CS       (CS),  // I
        .CK       (CK),  // I
        .STDBY    (1'b0),  // I
        .SLEEP    (1'b0),  // I
        .PWROFF_N (1'b1),  // I
        .DO       (DO)   // O
    );
    // SB_SPRAM256KA ram (
    //     .ADDRESS       (AD),  // I
    //     .DATAIN       (DI),  // I
    //     .MASKWREN   (MASKWE),  // I
    //     .WREN       (WE),  // I
    //     .CHIPSELECT       (CS),  // I
    //     .CLOCK       (CK),  // I
    //     .STANDBY    (1'b0),  // I
    //     .SLEEP    (1'b0),  // I
    //     .POWEROFF (1'b1),  // I
    //     .DATAOUT       (DO)   // O
    // );
`else

    reg [15:0] Mem [0:8191] /* synthesis syn_ramstyle="SRAM" */;
    reg [15:0] do_int;
    reg [13:0] ad_reg;
    reg cs_reg;
    reg we_reg;

    // assign DO = Mem[AD];
    assign DO = do_int;

    always @(posedge CK) begin
        ad_reg <= AD;
        cs_reg <= CS;
        we_reg <= WE;
        if (CS && WE) begin
            Mem[AD] <= DI;
        end
        if (cs_reg) begin
            do_int <= Mem[ad_reg];
        end
    end

`endif

endmodule