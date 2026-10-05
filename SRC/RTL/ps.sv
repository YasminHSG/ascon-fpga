// HADJ-SAID
// 10/03/2025
// PS : Couche de substitution

`timescale 1ns/1ps


import ascon_pack::*;
// Déclaration des variables d'entrée et de sortie qui sont de type type_state
module ps (
input type_state state_i,
output type_state substitution_o);

//declaration variable pour généricité 

genvar i; 
generate 
	for( i = 0; i<64 ; i++)
	begin : g_sbox  // label obligatoire
	sbox inst_sbox(
		.sbox_i({state_i[0][i],state_i[1][i],state_i[2][i],state_i[3][i],state_i[4][i]}),
		.sbox_o({substitution_o[0][i],substitution_o[1][i],substitution_o[2][i],substitution_o[3][i],substitution_o[4][i]})); 
	end : g_sbox
endgenerate
endmodule
