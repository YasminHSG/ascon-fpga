//HADJ-SAID
// registre.sv
// 17/03/2025

`timescale 1ns/1ps

import ascon_pack::*;

module registre(
input type_state state_i,
input logic clock_i,
input logic resetb_i, 
input logic enable_i,
output type_state state_o
);

type_state state_s;

// sequential procress
always@(posedge clock_i or negedge resetb_i) 
begin : seq_0
	if( resetb_i == 1'b0)
// non blocking assignment <=
		state_s <= { '0, '0, '0, '0, '0};
	else begin 
		if (enable_i == 1'b1)
		state_s <= state_i;
		else
		state_s <= state_s; // memorisation
		end
	end : seq_0

assign state_o = state_s;

endmodule : registre
