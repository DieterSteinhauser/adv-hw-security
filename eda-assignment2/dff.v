`timescale 1ns / 1ps

module dff (CK, RST, D, Q);
	input CK;
	input RST;
	input D;
	output Q;

	reg Q;

  always @ (posedge CK or negedge RST) begin
	if (!RST) Q <= 1'b0;
	else Q <= D;
  end

endmodule
