// ==============================================================================
// --
//
// Version      : V 1.0
// Creation     : 02/09/2019
// Update       : --
// Created by   : KHOYRATEE Farad
// Updated by   : KHOYRATEE Farad
// 
// Description  : 
//
// Update       : 	
//
// ===============================================================================

module RAM#(DATASIZE=12, ADDRSIZE = 7, MEMSIZE=255)(clk, enw, addr, datai, datao);
	input 					clk;
	input 					enw;
	input [ADDRSIZE-1:0]	addr=0;
	
	input [DATASIZE-1:0]	datai;
	output[DATASIZE-1:0]	datao;
	
    reg [DATASIZE:0] memory [0:MEMSIZE] = {default:{default:0}};

    always @(posedge clk) begin
        if (enw) begin
            memory[addr] <= datai;
        end
    end

    assign datao = memory[addr];

endmodule