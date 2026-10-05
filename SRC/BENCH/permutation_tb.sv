//HADJ-SAID
// permutation_tb.sv
// 28/03/2025

`timescale 1ns/1ps

import ascon_pack::*;
module permutation_tb();

//DECLARATION DES SIGNAUX
type_state permutation_i;
// reg state
logic clock_i;
logic resetb_i;
logic enable_i;
// add
logic [3 : 0] round_i; 
// multiplexeur
logic input_node_i;
// sortie
type_state permutation_o;

 
// INSTANCE DU MODULE PERMUTATION

permutation DUT( 
	.permutation_i(permutation_i),
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.enable_i(enable_i),
	.round_i(round_i),
	.input_node_i(input_node_i),
	.permutation_o(permutation_o)
);
// stimuli+

// on crée la clock à l'infini
initial begin 
	clock_i = 1'b0;
	forever #5 clock_i = ~clock_i;
// on a fait un clocke de période 10 
end

//début du stimuli 
initial begin
// initialisation des signaux


	permutation_i[0] = 64'h00001000808C0001;
	permutation_i[1] = 64'h6CB10AD9CA912F80;
	permutation_i[2] = 64'h691AED630E81901F;
	permutation_i[3] = 64'h0C4C36A20853217C;
	permutation_i[4] = 64'h46487B3E06D9D7A8;

	resetb_i = 1'b0;
	
	enable_i = 1'b0;

	round_i = 4'b0;

	input_node_i = 1'b0; // on prend l'entrée extérieure grâce au mux
	
	#5
	resetb_i = 1'b1;
	#5
	enable_i = 1'b1;
	#10
	input_node_i = 1'b1;
	round_i = 4'h1;

	// le reset est actif au niveau bas, on le passe à 1 et on active le enable_s pour activer le processus 

	

	// on attend un cycle pour visualiser un état inital avant de passer 
	#10
	// initialisons round_s

	// On crée alors une boucle pour itérer les permutations


	for(int i = 1; i<11; i++) begin 
		round_i = round_i + 4'b1;
		#10; // on attend un clycle de l'horloge
	end 
	// lorsqu'on a fini on arrete d'écrire

	enable_i = 1'b0;
	#20; 

end

endmodule : permutation_tb









