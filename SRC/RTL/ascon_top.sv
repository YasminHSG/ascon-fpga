//HADJ-SAID
// ascon_top.sv
// 15/04/2025
module ascon_top import ascon_pack::*;(


	input logic start_i,
	input logic data_valid_i,
	input logic resetb_i,
	input logic clock_i,
	input logic [127:0] data_i,
	input logic [127:0] key_i,
	input logic [127:0] nonce_i,
	output logic [127:0] cipher_o,
	output logic cipher_valid_o,
    output logic end_initialisation_o,
    output logic end_associated_o,
    output logic end_cipher_o,
    output logic [127:0] tag_o,
	output logic end_o


 );


//Déclaration des signaux internes
	logic [3:0] round_s;
	logic init_a_s,init_b_s,en_cpt_double_s;
	logic en_data_s;
//registre
	logic enable_reg_s;	
	logic input_node_s;
	//Xor begin et end
	logic bypass_xor_begin_s;
	logic finalisation_s;
	logic bypass_xor_end_s;
	logic xor_mode_end_s;


 
type_state permutation_i_s;
assign permutation_i_s ={64'h00001000808C0001,key_i[63:0], key_i[127:64],nonce_i[63:0],nonce_i[127:64]}; // On concatène pour avoir la donnée d'entrée conformément au sujet  //320'h00001000808C00016CB10AD9CA912F80691AED630E81901F0C4C36A20853217C46487B3E06D9D7A8; //{IV,key_i[63:0], key_i[127:0],nonce_i[63:0],nonce_i[127:64]}; // On concatène pour avoir la donnée d'entrée conformément au sujet 

// state_o
type_state state_o_s;

// instanciation de la FSM

fsm_moore FSM(
	//entrées
	.start_i(start_i),
	.data_valid_i(data_valid_i),
	.resetb_i(resetb_i), 
	.clock_i(clock_i),
	.round_i(round_s),	
	//Compteur de ronde 
	.init_a_o(init_a_s),
	.init_b_o(init_b_s),
	.en_cpt_double_o(en_cpt_double_s),
	.enable_o(enable_reg_s), //write enable du registre 
	.end_o(end_o), 
	.cipher_valid_o(cipher_valid_o),
	.input_node_o(input_node_s), // mux
	.bypass_xor_begin_o(bypass_xor_begin_s),
	.finalisation_o(finalisation_s),
	// pour piloter le Xor de fin
	.bypass_xor_end_o(bypass_xor_end_s), 
	.xor_mode_end_o(xor_mode_end_s),
    .end_initialisation_o(end_initialisation_o),
    .end_associated_o(end_associated_o),
    .end_cipher_o(end_cipher_o)
    //.tag_o(tag_o)
);

// Instanciation Permutation

permutation_xor_begin Permutation_xor_begin (
	.permutation_i(permutation_i_s),
	// pour piloter le Xor de début
	.bypass_xor_begin_i(bypass_xor_begin_s),
	.finalisation_i(finalisation_s),
	.data_i(data_i),
	.key_i(key_i),
	// pour piloter le Xor de fin
	.bypass_xor_end_i(bypass_xor_end_s), 
	.xor_mode_end_i(xor_mode_end_s),
	// pour le registre
	.resetb_i(resetb_i), 
	.enable_i(enable_reg_s),
	.clock_i(clock_i),
	// add
	.round_i(round_s),
	// multiplexeur
	.input_node_i(input_node_s),
	// sortie
	.permutation_o(state_o_s),
    .cipher_o(cipher_o),
    .tag_o(tag_o)

);

// Instanciation compteur de rondes 

compteur_double_init compteur_rondes(
	.clock_i(clock_i),
	.resetb_i(resetb_i),
	.en_i(en_cpt_double_s),
	.init_a_i(init_a_s),
	.init_b_i(init_b_s),
	.cpt_o(round_s)
);


endmodule : ascon_top