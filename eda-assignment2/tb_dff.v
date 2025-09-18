`timescale 1ns / 1ps

module dff_tb();

    // Inputs
    reg D;
    reg CK;
    reg RST;

    // Outputs
    wire Q;

    dff uut (CK, RST, D, Q);

    always // clock with period 1000ns
    begin
        clk = 1;
        #50;
        clk = !clk;
        #50;
    end
    
    // Test Patterns
    initial 
    begin

        // Flash the reset on the DUT
        RST = 1'b1;
        D = 1'b1;
        #80;

        RST = 1'b0;
        #80;
        RST = 1'b1;
        
        forever #30 D=~ D;
    end
        
    initial 
    begin
        $dumpfile("dff_sim.vcd");
        $dumpvars();
    end
    
endmodule