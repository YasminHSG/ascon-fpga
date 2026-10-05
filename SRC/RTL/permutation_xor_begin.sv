//HADJ-SAID
// permutation_xor_end.sv
// 15/04/2025

`timescale 1ns/1ps

import ascon_pack::*;
module permutation_xor_begin(


input type_state permutation_i,

// pour piloter le Xor de début

input logic bypass_xor_begin_i,
input logic finalisation_i,
input logic[127:0] data_i,
input logic[127:0]  key_i,

// pour piloter le Xor de fin
input logic bypass_xor_end_i,
// input logic[127:0]  key_i,  on commente car la clé a déjà été définie précédemment. 
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
output type_state permutation_o,
output logic [127:0] cipher_o,
output logic [127:0] tag_o

);

// entrées sorties locales 
type_state state_mux_s;
type_state state_xor_begin_s;
type_state state_add_s;
type_state state_sub_s;
type_state state_diff_s;
type_state state_xor_end_s;
type_state state_o_s;

// Ceci est le multiplexeur (pour input_node_i = 0, on prend l'entrée permutation_i, pour input_node_i = 1, on prend la valeur de state_o_s)
assign state_mux_s = (input_node_i)? state_o_s : permutation_i; 

// Le Xor begin se place entre la sortie du mux et l'entre de "constant addition"


xor_begin Xor_begin(
	. state_i(state_mux_s),
	. bypass_xor_begin_i(bypass_xor_begin_i),
	. finalisation_i(finalisation_i),
	. data_i(data_i),
	. key_i(key_i),
	. state_xor_begin_o(state_xor_begin_s)

);

assign cipher_o = {state_xor_begin_s[1], state_xor_begin_s[0]};
assign tag_o = {state_o_s[4],state_o_s[3]};
/*
always@(bypass_xor_begin_i, key_i, finalisation_i, data_i, state_mux_s)begin : xor_begin
		if(bypass_xor_begin_i == 1) state_xor_begin_s = state_mux_s;

	else begin : cond_sur_fin
		if(finalisation_i == 1) begin : fin1
			state_xor_begin_s[0] = state_mux_s[0]^data_i[127:64];
			state_xor_begin_s[1] = state_mux_s[1]^data_i[63:0];
			state_xor_begin_s[2] = state_mux_s[2]^key_i[63:0];
			state_xor_begin_s[3] = state_mux_s[3]^key_i[127:64];
			state_xor_begin_s[4] = state_mux_s[4];
		end : fin1

		else begin : fin2
			state_xor_begin_s[0] = state_mux_s[0]^data_i[127:64];
			state_xor_begin_s[1] = state_mux_s[1]^data_i[63:0];
			state_xor_begin_s[2] = state_mux_s[2];
			state_xor_begin_s[3] = state_mux_s[3];
			state_xor_begin_s[4] = state_mux_s[4];
		end : fin2
	
	end : cond_sur_fin
		

end : xor_begin
*/

// passage par constant_addition

constant_addition Pc(
	.state_i(state_xor_begin_s),
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

registre Registre(
	.state_i(state_xor_end_s),
	.clock_i(clock_i),
	.resetb_i(resetb_i), 
	.enable_i(enable_i),
	.state_o(state_o_s)
);

assign permutation_o = state_o_s;

endmodule : permutation_xor_begin
