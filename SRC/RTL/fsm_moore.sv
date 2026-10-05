//HADJ-SAID
// fsm_moore.sv
// 15/04/2025

// Commençons par la phase d'initialisation de la FSM
module fsm_moore import ascon_pack::*;( 
// mettre les entrées
input logic start_i,
input logic data_valid_i,
input logic resetb_i, 
input logic clock_i,
input logic [3:0] round_i,

//sorties	

//Compteur de ronde 
output logic init_a_o,
output logic init_b_o,
output logic en_cpt_double_o,

//write enable du registre 
output logic enable_o,


output logic end_o, 
output logic cipher_valid_o,
output logic input_node_o, // dit quelle entrée du mux prendre ici en output car ça va vers la permutation
// pour piloter le Xor de début

output logic bypass_xor_begin_o,
output logic finalisation_o,
// pour piloter le Xor de fin
output logic bypass_xor_end_o, 
output logic xor_mode_end_o,

output logic end_initialisation_o,
output logic end_associated_o,
output logic end_cipher_o
//output logic tag_o

);


typedef enum{ idle, conf_init, end_conf_init, init, end_init, xor_begin_da, permutations_da, xor_end_da,xor_begin_1_tc,
perm_1_tc,conf_xor_begin_2_tc, xor_begin_2_tc, perm_2_tc, conf_xor_begin_3_tc, xor_begin_fin, permutations_fin, xor_end_fin
} state_t;
//On énumère les états de la fsm

//déclaration de 2 variables pour l'état 
state_t current_state; 
state_t next_state; 



//modélisation du registre des états
always_ff@(posedge clock_i, negedge resetb_i)
	begin : seq_0
	if( resetb_i == 1'b0)
		current_state <= idle; 
	else current_state <= next_state;
	end : seq_0

//modélilsation des transitions
always_comb
begin : comb_0
	case(current_state)
		idle : if(start_i == 1'b1) 
				next_state = conf_init; 
			else 
				next_state = idle; 
		conf_init : next_state = end_conf_init;
	
		end_conf_init : next_state = init;

		init : if(round_i == 4'hA ) next_state = end_init; 
			// pour dire que round_i doit être égal à 10, c'est la boucle
			else next_state = init; 
			
		end_init : next_state = xor_begin_da; 

// avant de fermer un always comb il faut un cas default. On affecte alors à next_state une valeur par défaut

		xor_begin_da : next_state = permutations_da;
		permutations_da : if(round_i == 4'hA) next_state = xor_end_da;
				else next_state = permutations_da;
		xor_end_da : next_state = xor_begin_1_tc;
		xor_begin_1_tc : next_state = perm_1_tc;
		perm_1_tc : if(round_i == 4'hA) next_state = conf_xor_begin_2_tc;
				else next_state = perm_1_tc;
		conf_xor_begin_2_tc : next_state = xor_begin_2_tc;

		xor_begin_2_tc : next_state = perm_2_tc;
		perm_2_tc : if( round_i == 4'hA) next_state = conf_xor_begin_3_tc;
			else next_state = perm_2_tc;
		conf_xor_begin_3_tc : next_state = xor_begin_fin;
		xor_begin_fin : next_state = permutations_fin ;
		permutations_fin : if( round_i == 4'hA) next_state = xor_end_fin;
			else next_state = permutations_fin;
		default : next_state = idle; 
		endcase
end : comb_0



// modélisation des sorties 

always_comb 
begin : comb_1
// valeurs par défaut pour chaque sortie on affecte une fois aux 16 sorties leurs valeurs au début i.e. ici

// puis on modifie celle souhaitée dans chaque case 
 

//Compteur de ronde : on ne compte pas, c'est une attente

		init_a_o = 1'b0;
		init_b_o = 1'b0;
		en_cpt_double_o = 1'b0;

		end_o = 1'b0; // ce n'est pas la fin
		cipher_valid_o = 1'b0;
		input_node_o = 1'b1; // prise de la valeur extérieure 
		

		enable_o = 1'b1; 
		end_initialisation_o = 1'b0;
		
		// xor begin : on ne Xor pas 
		bypass_xor_begin_o = 1'b1;
		finalisation_o = 1'b0;
		//xor end : on ne Xor pas 
		bypass_xor_end_o = 1'b1;
		xor_mode_end_o = 1'b0;
		end_associated_o = 1'b0;
		end_cipher_o = 1'b0;
		end_o = 1'b0;

		enable_o = 1'b1; // On écrit dans le registre
	case(current_state)
	idle : begin	
		enable_o = 1'b0;
		end
	conf_init : begin 
		en_cpt_double_o = 1'b1;
		init_a_o = 1'b1;
		enable_o = 1'b0;

		end
	end_conf_init : begin
		en_cpt_double_o = 1'b1;
		init_a_o = 1'b0;
		input_node_o = 1'b0;
		end 
	init : begin
		en_cpt_double_o = 1'b1;
		end
	end_init : begin // j'active le xor_end !!
		en_cpt_double_o = 1'b1;
		xor_mode_end_o = 1'b0; 
		bypass_xor_end_o = 1'b0;
		enable_o = 1'b1;
		end_initialisation_o = 1'b1;
		init_b_o = 1'b1;
		end


	xor_begin_da :begin
		bypass_xor_end_o = 1'b1; // on finit de xorer en bas
		init_b_o = 1'b0;
		en_cpt_double_o = 1'b1;
		bypass_xor_begin_o = 1'b0;
		finalisation_o = 1'b0;
		end 
	permutations_da :begin
		init_b_o = 1'b0;
		en_cpt_double_o = 1'b1;
		bypass_xor_begin_o = 1'b1; // finalisation_o par défaut à la bonne valeur
		end 
	xor_end_da : begin
		en_cpt_double_o = 1'b1; 
		bypass_xor_end_o = 1'b0; 
		xor_mode_end_o = 1'b1;
		init_b_o = 1'b1;
		end_associated_o = 1'b1;
		end 


	xor_begin_1_tc : begin
			en_cpt_double_o = 1'b1; 
			bypass_xor_end_o = 1'b1; 
			bypass_xor_begin_o = 1'b0;
			init_b_o = 1'b0;
			end 

	perm_1_tc : begin
			en_cpt_double_o = 1'b1; 
			bypass_xor_begin_o = 1'b1; 
			
			end
	conf_xor_begin_2_tc : begin
			en_cpt_double_o = 1'b1; 
			init_b_o = 1'b1;
			end_cipher_o = 1'b1;
			end
	xor_begin_2_tc : begin
			en_cpt_double_o = 1'b1; 
			init_b_o = 1'b0;
			bypass_xor_begin_o = 1'b0; 
			
			end

	perm_2_tc : begin
			en_cpt_double_o = 1'b1; 
			bypass_xor_begin_o = 1'b1; 
			end

	conf_xor_begin_3_tc : begin
			en_cpt_double_o = 1'b1; 
			init_a_o = 1'b1; 
			
			end

	xor_begin_fin : begin
			en_cpt_double_o = 1'b1; 
			init_a_o = 1'b0;
			bypass_xor_begin_o = 1'b0;
			finalisation_o = 1'b1; 
			end_cipher_o = 1'b1;
			end
	permutations_fin : begin
			en_cpt_double_o = 1'b1; 
			bypass_xor_begin_o = 1'b1;
		end
	xor_end_fin : begin 
		en_cpt_double_o = 1'b1; 
		bypass_xor_end_o = 1'b0;
		end_o = 1'b1;

	end
	endcase
end : comb_1



endmodule : fsm_moore

