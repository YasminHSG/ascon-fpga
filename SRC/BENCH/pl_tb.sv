//HADJ-SAID
// TEST BENCH DU PS 
// 17/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module pl_tb();

//declaration des signaux 
type_state state_i_s;
type_state substitution_o_s;
 
// instance du module ps

pl DUT( 
	.state_i(state_i_s),
	.diffusion_o(substitution_o_s));

// stimuli

initial begin 
state_i_s[0] = 64'h25f7c341c45f9912;
state_i_s[1] = 64'h23b794c540876856;
state_i_s[2] = 64'hb85451593d679610;
state_i_s[3] = 64'h4fafba264a9e49ba;
state_i_s[4] = 64'h62b54d5d460aded4;



#50;
end

endmodule : pl_tb
