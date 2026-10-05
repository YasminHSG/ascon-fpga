//HADJ-SAID
// permutation_tb.sv
// 28/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module permutation_xor_end_tb();

//DECLARATION DES SIGNAUX

// entrée
type_state permutation_i; 

// multiplexeur
logic input_node_i; 

// add
logic [3 : 0] round_i;

// ps et pl n'ont besoin d'aucune entrée supplémentaire

//xor_end
logic bypass_xor_end_i; 
logic[127:0]  key_i;
logic xor_mode_end_i; 

// reg_state
logic clock_i; 
logic resetb_i; 
logic enable_i; 

// sortie
type_state permutation_o;
 
// INSTANCE DU MODULE PERMUTATION

permutation_xor_end DUT( 
	.permutation_i(permutation_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.enable_i(enable_i),
	.round_i(round_i),
	.input_node_i(input_node_i),
	.permutation_o(permutation_o),
	.bypass_xor_end_i(bypass_xor_end_i),
	.key_i(key_i),
	.xor_mode_end_i(xor_mode_end_i)
);
// stimuli

// on crée la clock à l'infini
initial begin 
	clock_i = 1'b0;
	forever #5 clock_i = ~clock_i;
// on a fait une clock de période 10 
end

//début du stimuli 
initial begin
// initialisation des signaux

	
	// la valeur en entrée
	permutation_i[0] = 64'h00001000808C0001;
	permutation_i[1] = 64'h6CB10AD9CA912F80;
	permutation_i[2] = 64'h691AED630E81901F;
	permutation_i[3] = 64'h0C4C36A20853217C;
	permutation_i[4] = 64'h46487B3E06D9D7A8;

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
	#20; // on attend 2 cycles de l'horloge

	// lorsqu'on a fini on arrete d'écrire
	enable_i = 1'b0;
	#20; 

end

endmodule : permutation_xor_end_tb









