`timescale 1ns/1ps

module test();

    reg clk;
    reg rst;
    wire [2:0] mc_state;
    wire [2:0] rc_state;
    assign rc_out = rc_state[2];
    wire mc_out;

    integer fail = 0;
    integer i;

    top uut(
        .btnC(clk),
        .btnU(rst),
        .led({mc_out, mc_state, rc_state})
    );

    initial begin
        $dumpvars(0,test);
        clk = 0;
        rst = 1;
        #10;
        rst = 0;
        #10;

        //Test 1: Check if modulo counter flips state after 7 clock cycles
        for (i = 0; i < 14; i = i + 1) begin
            #1 clk = ~clk;
        end
        #5;
        // We should have toggled the /6 modulo counter
        if (mc_out !== 1'b1) begin
            fail = 1;
            $display("Test 1: Failed to trigger the modulo counter");
        end

        //Test 2: After additional 1 clock cycle, check if the ring counter resets after counting down from 7 to 0
        for (i = 0; i < 2; i = i + 1) begin
            #1 clk = ~clk;
        end
        #5;
        // We should have toggled the /8 ring counter
        if (rc_state[2] !== 1'b0) begin
            fail = 1;
            $display("Test 2: Failed to toggle final bit of the ring counter output off");
        end
 
        //Test 3: After additional 7 clock cycles, check if modulo counter has reset
        for (i = 0; i < 14; i = i + 1) begin
            #1 clk = ~clk;
        end
        #5;
        // We should have toggled the /6 modulo counter
        if (mc_out !== 1'b0) begin
            fail = 1;
            $display("Test 3: Reset logic in modulo counter is wrong");
        end
        
        if (!fail)
            $display("All Testcases Passed!");
        else 
            $error("Failing Testcases!");
        
        #5; $finish;
        
    end

endmodule