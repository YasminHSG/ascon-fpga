//HADJ-SAID
// TEST BENCH DE LA SBOX 
// 17/03/2025

`timescale 1ns/1ps

module sbox_tb();

//declaration des signaux 

logic[4:0] sbox_i_s;
logic [4:0] sbox_o_s;

// instance du module sbox

sbox DUT( 
	.sbox_i(sbox_i_s),
	.sbox_o(sbox_o_s));

// stimuli

initial begin

	

	sbox_i_s = 5'h00;
	#25
	sbox_i_s = 5'h01;
	#25
	sbox_i_s = 5'h02;
	#25
	sbox_i_s = 5'h03;
	#25
	sbox_i_s = 5'h04;
	#25;
end

endmodule : sbox_tb
