`timescale 1ns/1ps

import ascon_pack::*;
module xor_begin_tb();

//DECLARATION DES SIGNAUX

type_state permutation_i;

// pour piloter le Xor de début

logic bypass_xor_begin_i;
logic finalisation_i;
logic[191:0] data_i;
logic[127:0]  key_i;
type_state permutation_o;

// INSTANCE DU MODULE XOR BEGIN

xor_begin DUT( 
	// xor_begin
	.state_i(permutation_i),
 	.bypass_xor_begin_i(bypass_xor_begin_i),
 	.finalisation_i(finalisation_i),
 	.data_i(data_i),
	.key_i(key_i),
	.state_xor_begin_o(permutation_o)
);
// stimuli

initial begin
// initialisation des signaux

	// la valeur en entrée
	permutation_i[0] = 64'h82bf91294ba5808d;
	permutation_i[1] = 64'hd81eeca694136f8a;
	permutation_i[2] = 64'h0217bc9ebd9fff02;
	permutation_i[3] = 64'h2163C2A59353D4C8;
	permutation_i[4] = 64'h2731CDA0E76AA05B; 
	

	// entrons la valeur de la clé
	key_i = 128'h691AED630E81901F6CB10AD9CA912F80;

	// entrons la valeur de data_i
	data_i = {32'h0001, 96'h626F42206F74206563696C41};


// par la suite on utilise le xor up sur Sr
	// on dit qu'on xor
	bypass_xor_begin_i = 0;
	// puis on dit qu'on est en mode DA en chiffrement 
	finalisation_i = 0; 
	# 20; // On attend encore 2 cycles d'horloge 
end


endmodule : xor_begin_tb
