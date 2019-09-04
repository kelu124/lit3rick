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

// Constant values for DAC
`define DAC1VAL  'hF2B
`define DAC2VAL  'hC32

// Memory parameters
`define ADDRSIZE 7
`define MEMSIZE  255

module top(clk, reset, en_acq, RAM_enr, RAM_datao, ADC_data, DAC_mosi1, DAC_mosi2);
	input 	clk;
	input 	reset;
	input 	en_acq;
	input 	RAM_enr;
	
	input [`ADCDATA-1:0]	ADC_data=0;
	output [`ADCDATA-1:0]	RAM_datao;
	output 					DAC_mosi1;
	output 					DAC_mosi2;
	
	/********** Flip-flop to synchronize inputs **********/
	
	// Synchronize enable
	reg 				en_acquisition;
	always @ (posedge clk)
	begin
		if (reset == 1)
			en_acquisition 	<= 0;
		else
			en_acquisition 	<= en_acq;
		end
	
	// Synchronize data from ADC
	reg [`ADCDATA-1:0]	ADCsync_data;
	always @ (posedge clk)
	begin
		if (reset == 1)
			ADCsync_data	<= 0;
		else
			ADCsync_data 	<= ADC_data;
		end
	
	/********** Acquisition   **********/
	wire 					en_write;
	wire [`ADDRSIZE-1:0]	RAM_addr;
	acquisition #(`NSAMPLE, `ADDRSIZE) acq(clk, reset, en_acquisition, en_write, RAM_addr);
	
	/********** Memory handle **********/
	//RAM for saving acquired
	wire [`ADDRSIZE-1:0] 	  datao;
	assign RAM_datao 		= datao;
	RAM #(`ADCDATA, `ADDRSIZE, `MEMSIZE) mem(clk, en_write, RAM_addr, ADCsync_data, datao);
	
	/********** Serialize data for DAC **********/
	// Serialize the constant for SPI transmission
	parameter [`DACDATA-1:0] DAC_data1 	= `DAC1VAL;
	assign DAC_mosi1 = DAC_datao1;
	serializer ser1(clk, reset, en_acquisition, DAC_data1, DAC_datao1);
	
	// Serialize the constant for SPI transmission
	parameter [`DACDATA-1:0] DAC_data2 	= `DAC2VAL;
	assign DAC_mosi2 = DAC_datao2;
	serializer ser2(clk, reset, en_acquisition, DAC_data2, DAC_datao2);
	
endmodule