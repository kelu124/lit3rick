module up5kPLL(PACKAGEPIN,
               PLLOUTCORE,
               PLLOUTGLOBAL,
               RESET);

inout PACKAGEPIN;
input RESET;    /* To initialize the simulation properly, the RESET signal (Active Low) must be asserted at the beginning of the simulation */ 
output PLLOUTCORE;
output PLLOUTGLOBAL;

SB_PLL40_PAD up5kPLL_inst(.PACKAGEPIN(PACKAGEPIN),
                          .PLLOUTCORE(PLLOUTCORE),
                          .PLLOUTGLOBAL(PLLOUTGLOBAL),
                          .EXTFEEDBACK(),
                          .DYNAMICDELAY(),
                          .RESETB(RESET),
                          .BYPASS(1'b0),
                          .LATCHINPUTVALUE(),
                          .LOCK(),
                          .SDI(),
                          .SDO(),
                          .SCLK());

//\\ Fin=12, Fout=192;
defparam up5kPLL_inst.DIVR = 4'b0000;
defparam up5kPLL_inst.DIVF = 7'b0111111;
defparam up5kPLL_inst.DIVQ = 3'b010;
defparam up5kPLL_inst.FILTER_RANGE = 3'b001;
defparam up5kPLL_inst.FEEDBACK_PATH = "SIMPLE";
defparam up5kPLL_inst.DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED";
defparam up5kPLL_inst.FDA_FEEDBACK = 4'b0000;
defparam up5kPLL_inst.DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED";
defparam up5kPLL_inst.FDA_RELATIVE = 4'b0000;
defparam up5kPLL_inst.SHIFTREG_DIV_MODE = 2'b00;
defparam up5kPLL_inst.PLLOUT_SELECT = "GENCLK";
defparam up5kPLL_inst.ENABLE_ICEGATE = 1'b0;

endmodule
