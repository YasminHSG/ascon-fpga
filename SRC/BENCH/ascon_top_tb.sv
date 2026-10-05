
//                              -*- Mode: Verilog -*-
// Filename        : permutation_full_tb.sv
// Description     : package definition
// Author          : Jean-Baptiste RIGAUD
// Created On      : Sat Oct 14 15:30:30 2023
// Last Modified By: Jean-Baptiste RIGAUD
// Last Modified On: Sat Oct 14 15:30:30 2023
// Update Count    : 0
// Status          : Unknown, Use with caution!
`timescale 1 ns / 1 ps

module ascon_top_tb
  import ascon_pack::*;
(
    //vide
);

  logic clock_s;
  logic resetb_s;
  logic start_s;
  logic [127:0] key_s;
  logic [127:0] nonce_s;
  logic [127:0] data_s;
  logic data_valid_s;
  logic cipher_valid_s;
  logic [127:0] cipher_s;
  logic end_s;
  logic end_initialisation_s;
  logic end_associated_s;
  logic end_cipher_s;

  logic [127:0] tag_s;

  ascon_top DUT (
      .clock_i(clock_s),
      .resetb_i(resetb_s),
      .start_i(start_s),
      .key_i(key_s),
      .nonce_i(nonce_s),
      .data_i(data_s),
      .data_valid_i(data_valid_s),
      .cipher_valid_o(cipher_valid_s),
      .cipher_o(cipher_s),
      .end_o(end_s),
      .end_initialisation_o(end_initialisation_s),
      .end_associated_o(end_associated_s),
      .end_cipher_o(end_cipher_s),
      .tag_o(tag_s)
  );

  //hologe
  initial begin
    clock_s = 0;
    forever #10 clock_s = ~clock_s;
  end
  //stimuli
  initial begin
    resetb_s = 0;
    key_s = 128'h691AED630E81901F6CB10AD9CA912F80;
    nonce_s = 128'h46487B3E06D9D7A80C4C36A20853217C;
    start_s = 0;
    data_s = '0;
    data_valid_s = 0;
    #40;
    $display("reset du circuit");
    resetb_s = 1;
    #100;
    $display("début du chiffrement");
    start_s = 1;
    #20;
    start_s = 0;
    do begin
      #20;
    end while (end_initialisation_s != 1'b1);
    $display("fin de la phase d'initialisation");
    
    data_s = 128'h00000001626F4220_6F74206563696C41;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;
    do begin
      #20;
    end while (end_associated_s != 1'b1);
    $display("fin de la phase de traitement des données associées");
    data_s = 128'h704F206572696420_7475657620657551;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;
    do begin
      #20;
    end while (end_cipher_s != 1'b1);
    $display("fin de la phase de traitement du premier bloc de données");
    
    data_s = 128'h766E492065617275_74614E2061747265;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;
    do begin
      #20;
    end while (end_cipher_s != 1'b1);
    $display("fin de la phase de traitement du deuxieme bloc de données");
    
    data_s = 128'h013F206172656E754_D20746E75696E65;
    data_valid_s = 1;
    #20;
    data_valid_s = 0;
    do begin
      #20;
    end while (end_s != 1'b1);
    $display("fin du chiffrement");
    

    #20;
    $stop();

  end


endmodule : ascon_top_tb
