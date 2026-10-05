// HADJ-SAID
//10/03/2025
// TEST BENCH de CONSTANT ADDITION

`timescale 1ns/1ps

import ascon_pack::*;
module constant_addition_tb(
// empty declarative part
);

//Déclaration des variables 
type_state statein_s;
logic[3:0] round_s;
type_state stateout_s;


// lien entre les variables locales et ce qu'on récupère de constant_addition.sv
constant_addition DUT(
	.state_i(statein_s),
	.round_i(round_s),
	.state_o(stateout_s)
);

//stimuli de test

initial 
begin 
	statein_s[0] = 64'h00001000808C0001;
	statein_s[1] = 64'h6CB10AD9CA912F80;
	statein_s[2] = 64'h691AED630E81901F;
	statein_s[3] = 64'h0C4C36A20853217C;
	statein_s[4] = 64'h46487B3E06D9D7A8;

round_s = 4'h0; 

#50

	statein_s[0] = 64'h932c16dd634b9585;
	statein_s[1] = 64'hb48a3c3fe8fb45ce;
	statein_s[2] = 64'ha69f28b0c721c3a1;
	statein_s[3] = 64'h05e1761f1e1fcb67;
	statein_s[4] = 64'h64d322a896b791cf;

round_s = 4'h1;
#50;

end 


endmodule : constant_addition_tb

