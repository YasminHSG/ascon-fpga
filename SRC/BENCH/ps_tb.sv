//HADJ-SAID
// TEST BENCH DU PS 
// 17/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module ps_tb();

//declaration des signaux 
type_state state_i_s;
type_state substitution_o_s;
 
// instance du module ps

ps DUT( 
	.state_i(state_i_s),
	.substitution_o(substitution_o_s));

// stimuli

initial begin 
state_i_s[0] = 64'h00001000808c0001;
state_i_s[1] = 64'h6cb10ad9ca912f80;
state_i_s[2] = 64'h691aed630e8190ef;
state_i_s[3] = 64'h0c4c36a20853217c;
state_i_s[4] = 64'h46487b3e06d9d7a8;
/*On peut également tester avec une deuxième série de valeurs */
/*#50
state_i_s[0] = 64'h932c16dd634b9585;
state_i_s[1] = 64'hb48a3c3fe8fb45ce;
state_i_s[2] = 64'ha69f28b0c721c3a1;
state_i_s[3] = 64'h05e1761f1e1fcb67;
state_i_s[4] = 64'h64d322a896b791cf;*/


#50;
end

endmodule : ps_tb

