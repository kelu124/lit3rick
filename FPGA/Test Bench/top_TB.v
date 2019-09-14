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

`timescale 1ns/10ps

// Size of data from ADC and DAC
`define ADCDATA  12
`define DACDATA  12

// Number of sample to save from ADC
`define	NSAMPLE  10

// Memory parameters
`define ADDRSIZE 7
`define MEMSIZE  255

module top_TB;
	reg clk;
	reg reset;
	
	reg en_acq;
	reg RAM_enr;
	reg [`ADCDATA-1:0] ADC_data = 0;
	wire 				RAM_datao;
	wire 				DAC_mosi1;
	wire 				DAC_mosi2;
	
	parameter p = 2;
	top tp(clk, reset, en_acq, RAM_enr, RAM_datao, ADC_data, DAC_mosi1, DAC_mosi2);
	
	initial
	begin
		en_acq 	= 0;
		RAM_enr	= 0;
		reset 	= 0;
		#p 		en_acq 	= 1;
		#(p*6)	en_acq	= 0;
	end
	
	// Generate clock
	initial
	begin
		clk = 0;
		#(p/4) forever #(p/2) clk = ~clk;
	end
	
	// Simulate data sent from ADC
	initial
	begin
		forever #p ADC_data = data;
	end
	
	reg [`ADCDATA-1:0]	data=0;
	always @(posedge clk)
	begin
		if (data < 255)
		begin
			data 		<= data + 1;
		end
	end
	
endmodule