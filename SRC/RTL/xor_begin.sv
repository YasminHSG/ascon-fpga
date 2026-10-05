//HADJ-SAID
// xor_begin.sv
// 20/04/2025


`timescale 1ns/1ps


import ascon_pack::*;
// Déclaration des variables d'entrée et de sortie qui sont de type type_state
module xor_begin(

input type_state state_i,
input logic bypass_xor_begin_i,
input logic finalisation_i,
input logic[127:0] data_i,
input logic[127:0]  key_i,
output type_state state_xor_begin_o );



always@(bypass_xor_begin_i, key_i, finalisation_i, data_i, state_i )begin : xor_b
		if(bypass_xor_begin_i == 1) state_xor_begin_o = state_i;

	else begin : condition
		if(finalisation_i == 1) begin : fin1
			state_xor_begin_o[0] = state_i[0]^data_i[63:0];
			state_xor_begin_o[1] = state_i[1]^data_i[127:64];
			state_xor_begin_o[2] = state_i[2]^key_i[63:0];
			state_xor_begin_o[3] = state_i[3]^key_i[127:64];
			state_xor_begin_o[4] = state_i[4];
		end : fin1

		else begin : fin2
			state_xor_begin_o[0] = state_i[0]^data_i[63:0];
			state_xor_begin_o[1] = state_i[1]^data_i[127:64];
			state_xor_begin_o[2] = state_i[2];
			state_xor_begin_o[3] = state_i[3];
			state_xor_begin_o[4] = state_i[4];
		end : fin2
	
	end : condition
		

end : xor_b

endmodule : xor_begin

