module ADDFX1 (A, B, CI, CO, S);

input  A ;
input  B ;
input  CI ;
output CO ;
output S ;

endmodule

module ADDHX1 (A, B, CO, S);

input  A ;
input  B ;
output CO ;
output S ;

endmodule

module AND2X1 (A, B, Y);

input  A ;
input  B ;
output Y ;

endmodule

module AOI21X1 (A0, A1, B0, Y);

input  A0 ;
input  A1 ;
input  B0 ;
output Y ;

endmodule

module AOI22X1 (A0, A1, B0, B1, Y);

input  A0 ;
input  A1 ;
input  B0 ;
input  B1 ;
output Y ;

endmodule

module BUFX1 (A, Y);

input  A ;
output Y ;

endmodule

module BUFX3 (A, Y);
input  A ;
output Y ;

endmodule

module CLKBUFX1 (A, Y);

input  A ;
output Y ;

endmodule

module CLKBUFX2 (A, Y);

input  A ;
output Y ;

endmodule

module CLKBUFX3 (A, Y);

input  A ;
output Y ;

endmodule

module DFFSRX1 (CK, D, RN, SN, Q, QN);

input  CK ;
input  D ;
input  RN ;
input  SN ;
output Q ;
output QN ;

endmodule

module DFFX1 (CK, D, Q, QN);

input  CK ;
input  D ;
output Q ;
output QN ;
   
endmodule

module INVX1 (A, Y);

input  A ;
output Y ;

endmodule

module INVX2 (A, Y);

input  A ;
output Y ;

endmodule

module INVX4 (A, Y);

input  A ;
output Y ;

endmodule

module INVX8 (A, Y);

input  A ;
output Y ;

endmodule

module MX2X1 (A, B, S0, Y);

input  A ;
input  B ;
input  S0 ;
output Y ;

endmodule

module NAND2X1 (A, B, Y);

input  A ;
input  B ;
output Y ;

endmodule

module NAND2X2 (A, B, Y);

input  A ;
input  B ;
output Y ;

endmodule

module NAND3X1 (A, B, C, Y);

input  A ;
input  B ;
input  C ;
output Y ;

endmodule

module NAND4X1 (A, B, C, D, Y);

input  A ;
input  B ;
input  C ;
input  D ;
output Y ;

endmodule

module NOR2X1 (A, B, Y);

input  A ;
input  B ;
output Y ;

endmodule

module NOR3X1 (A, B, C, Y);

input  A ;
input  B ;
input  C ;
output Y ;

endmodule

module NOR4X1 (A, B, C, D, Y);

input  A ;
input  B ;
input  C ;
input  D ;
output Y ;

endmodule

module OAI21X1 (A0, A1, B0, Y);

input  A0 ;
input  A1 ;
input  B0 ;
output Y ;

endmodule

module OAI22X1 (A0, A1, B0, B1, Y);

input  A0 ;
input  A1 ;
input  B0 ;
input  B1 ;
output Y ;

endmodule

module OAI33X1 (A0, A1, A2, B0, B1, B2, Y);

input  A0 ;
input  A1 ;
input  A2 ;
input  B0 ;
input  B1 ;
input  B2 ;
output Y ;

endmodule

module OR2X1 (A, B, Y);

input  A ;
input  B ;
output Y ;

endmodule

module OR4X1 (A, B, C, D, Y);

input  A ;
input  B ;
input  C ;
input  D ;
output Y ;

endmodule

module SDFFSRX1 (CK, D, RN, SE, SI, SN, Q, QN);

input  CK ;
input  D ;
input  RN ;
input  SE ;
input  SI ;
input  SN ;
output Q ;
output QN ;

endmodule

module TBUFX1 (A, OE, Y);

input  A ;
input  OE ;
output Y ;

endmodule

module TBUFX2 (A, OE, Y);

input  A ;
input  OE ;
output Y ;

endmodule

module TBUFX4 (A, OE, Y);

input  A ;
input  OE ;
output Y ;

endmodule

module TBUFX8 (A, OE, Y);

input  A ;
input  OE ;
output Y ;

endmodule

module TINVX1 (A, OE, Y);

input  A ;
input  OE ;
output Y ;

endmodule

module TLATSRX1 (D, G, RN, SN, Q, QN);

input  D ;
input  G ;
input  RN ;
input  SN ;
output Q ;
output QN ;

endmodule

module TLATX1 (C, D, Q, QN);

input  C ;
input  D ;
output Q ;
output QN ;

endmodule

module XOR2X1 (A, B, Y);

input  A ;
input  B ;
output Y ;

endmodule

