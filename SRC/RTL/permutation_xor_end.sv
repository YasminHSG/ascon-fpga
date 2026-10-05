//HADJ-SAID
// permutation_xor_end.sv
// 17/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module permutation_xor_end(

input type_state permutation_i,

// pour piloter le Xor de fin
input logic bypass_xor_end_i,
input logic[127:0]  key_i,
input logic xor_mode_end_i,

// pour le registre

input logic resetb_i, 
input logic enable_i,
input logic clock_i,

// add
input logic [3:0] round_i,
// multiplexeur
input logic input_node_i,
// sortie
output type_state permutation_o

);

// entrées sorties locales 
type_state state_mux_s;
type_state state_add_s;
type_state state_sub_s;
type_state state_diff_s;
type_state state_xor_end_s;
type_state state_o_s;

// Ceci est le multiplexeur (pour input_node_i = 0, on prend l'entrée permutation_i, pour input_node_i = 1, on prend la valeur de state_o_s)

assign state_mux_s = (input_node_i)? state_o_s : permutation_i; 

// passage par constant_addition

constant_addition Pc(
	.state_i(state_mux_s),
	.round_i(round_i),
	.state_o(state_add_s)
);
// substitution (ps)
ps Ps( 
	.state_i(state_add_s),
	.substitution_o(state_sub_s)
);

// diffusion linéaire pl
pl Pl(
	.state_i(state_sub_s),
	.diffusion_o(state_diff_s)
);
xor_end Xor_end(
. state_i(state_diff_s),
. bypass_xor_end_i(bypass_xor_end_i),
. key_i(key_i),
. xor_mode_end_i(xor_mode_end_i),
. state_xor_end_o(state_xor_end_s)

);
/*
// On rajoute le xor de la fin entre la diffusion linéaire et le registre

always @(bypass_xor_end_i, xor_mode_end_i, state_diff_s) begin : xor_end
// Si on ne Xor pas, la sortie est égale à l'entée
	if(bypass_xor_end_i == 1) state_xor_s =  state_diff_s ;
// Si on Xor on cherche à savoir sur lequel on est d'où le xor_mode	
// Si mode_xor_end_i = 0, il s'agit du premier et du dernier xor
// si mode_xor_end_i = 1, il s'agit du deuxième xor
// Ces xor sont sur les parties basses du circuit	
	else begin
		if(xor_mode_end_i == 0)
			state_xor_s = state_diff_s ^ {key_i[63:0],key_i[127:64]};

		else
			state_xor_s = state_diff_s ^ {128'b0, 1'b1, 63'b0};
		end
end : xor_end*/


registre Registre(
	.state_i(state_xor_end_s),
	.clock_i(clock_i),
	.resetb_i(resetb_i), 
	.enable_i(enable_i),
	.state_o(state_o_s)
);

assign permutation_o = state_o_s;

endmodule : permutation_xor_end

