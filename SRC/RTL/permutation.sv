//HADJ-SAID
// permutation.sv
// 17/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module permutation(
input type_state permutation_i,

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

registre Registre(
	.state_i(state_diff_s),
	.clock_i(clock_i),
	.resetb_i(resetb_i), 
	.enable_i(enable_i),
	.state_o(state_o_s)
);

assign permutation_o = state_o_s;

endmodule : permutation


