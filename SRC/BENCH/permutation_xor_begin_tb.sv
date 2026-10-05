//HADJ-SAID
// permutation_tb.sv
// 28/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module permutation_xor_begin_tb();

//DECLARATION DES SIGNAUX

type_state permutation_i;

// pour piloter le Xor de début

logic bypass_xor_begin_i;
logic finalisation_i;
logic[191:0] data_i;
// logic[127:0]  key_i; c'est la même clé que pour le xor end


//reg state

logic clock_i;
logic resetb_i;
logic enable_i;
// add
logic [3 : 0] round_i;
// multiplexeur
logic input_node_i;
// sortie
type_state permutation_o;
logic bypass_xor_end_i;
logic[127:0]  key_i;
logic xor_mode_end_i;
 
// INSTANCE DU MODULE PERMUTATION

permutation_xor_begin DUT( 
	// xor_begin
	.permutation_i(permutation_i),
 	.bypass_xor_begin_i(bypass_xor_begin_i),
 	.finalisation_i(finalisation_i),
 	.data_i(data_i),
	//reg state
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.enable_i(enable_i),
	// add
	.round_i(round_i),
	//mux
	.input_node_i(input_node_i),
	//xor_end
	.bypass_xor_end_i(bypass_xor_end_i),
	.key_i(key_i),
	.xor_mode_end_i(xor_mode_end_i),
	//sortie 
	.permutation_o(permutation_o)
);
// stimuli

// on crée la clock à l'infini
initial begin 
	clock_i = 1'b0;
	forever #5 clock_i = ~clock_i;
// on a fait un clock de période 10 
end

//début du stimuli 
initial begin
// initialisation des signaux

	// entrons la valeur de la clé
	key_i = 128'h691AED630E81901F6CB10AD9CA912F80;

	// entrons la valeur de data_i
	data_i = {32'h0001, 96'h626F42206F74206563696C41};
	
	// la valeur en entrée
	permutation_i[0] = 64'h00001000808C0001;
	permutation_i[1] = 64'h6CB10AD9CA912F80;
	permutation_i[2] = 64'h691AED630E81901F;
	permutation_i[3] = 64'h0C4C36A20853217C;
	permutation_i[4] = 64'h46487B3E06D9D7A8;

	// On dit qu'on ne Xor pas au début et on initialise les signaux 
	bypass_xor_begin_i = 1; 
	finalisation_i = 0; 
	

	resetb_i = 1'b0; // On reset 
	
	enable_i = 1'b0; 

	round_i = 4'b0; //Compteur à zéro

	input_node_i = 1'b0; // on prend l'entrée extérieure grâce au mux

	
	// le reset est actif au niveau bas, on le passe à 1 et on active le enable_s pour activer le processus
	#5
	resetb_i = 1'b1;
	#5
	enable_i = 1'b1;
	#5
	bypass_xor_end_i = 1'b1; // on ne xor pas à la sortie de la première boucle  
	
	#10
	input_node_i = 1'b1; // on indique que l'on veut désormais la sortie de reg_state en sortie du multiplexeur
	round_i = 4'h1; // on initialise le compteur à 1

	// on attend un cycle pour visualiser un état inital avant de passer au suivant
	#10

	// On crée alors une boucle pour itérer les permutations

	 
	for(int i = 1; i<10; i++) begin 
		round_i = round_i + 4'b1;
		#10; // on attend un clycle de l'horloge
	end 

	// on doit alors xorer ici 

	bypass_xor_end_i = 1'b0; // on dit qu'on xor
	xor_mode_end_i = 1'b0; // on dit quel xor_down on prend 0 car on veut le premier 
	round_i = round_i + 4'b1;
	#10; // on attend 1 cycles de l'horloge
	round_i = 4'd4;
	// lorsqu'on a fini on arrete d'écrire
	// par la suite on utilise le xor up sur Sr
	// on dit qu'on xor
	bypass_xor_end_i=1'b1;
	bypass_xor_begin_i = 0;
	// puis on dit qu'on est en mode DA en chiffrement 
	finalisation_i = 0; 
	# 20; // On attend encore 2 cycles d'horloge 

	enable_i = 1'b0;
	#20; 

end

endmodule : permutation_xor_begin_tb









