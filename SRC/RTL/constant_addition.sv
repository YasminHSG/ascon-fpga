// HADJ-SAID
// 10/03/2025
// ADDITION DE CONSTANTE

`timescale 1ns/1ps

//Importation du module
import ascon_pack::*;
// Déclaration des variables d'entrée et de sortie
module constant_addition (
	input type_state state_i,
	input logic [3:0] round_i,
	output type_state state_o );

// Assignation des variables
// La sortie reste la même pour les registres 0, 1, 3 et 4.
// Les changements s'opèrent sur registre 2, 
assign state_o[0][ 63:0]=state_i[0][ 63:0];
assign state_o[1][ 63:0]=state_i[1][ 63:0];

assign state_o[2][ 63:8]=state_i[2][ 63:8];
assign state_o[2][ 7:0]=state_i[2][ 7:0]^round_constant[round_i];

assign state_o[3][ 63:0]=state_i[3][ 63:0];
assign state_o[4][ 63:0]=state_i[4][ 63:0];

endmodule : constant_addition
