//HADJ-SAID
// xor_end.sv
// 17/03/2025


`timescale 1ns/1ps


import ascon_pack::*;
// Déclaration des variables d'entrée et de sortie qui sont de type type_state
module xor_end(
input type_state state_i,
input logic bypass_xor_end_i,
input logic[127:0]  key_i,
input logic xor_mode_end_i,
output type_state state_xor_end_o);

always @(bypass_xor_end_i, xor_mode_end_i, state_i) begin : xor_e
// Si on ne Xor pas, la sortie est égale à l'entée
	if(bypass_xor_end_i == 1) state_xor_end_o =  state_i ;
// Si on Xor on cherche à savoir sur lequel on est d'où le xor_mode	
// Si mode_xor_end_i = 0, il s'agit du premier et du dernier xor
// si mode_xor_end_i = 1, il s'agit du deuxième xor
// Ces xor sont sur les parties basses du circuit	
	else begin
		if(xor_mode_end_i == 0)
			state_xor_end_o = state_i ^ {key_i[63:0],key_i[127:64]};

		else
			state_xor_end_o = state_i ^ {128'b0, 1'b1, 63'b0};
		end
end : xor_e

endmodule : xor_end
