`default_nettype none
`define DUMPSTR(x) "x.vcd"
`timescale 1ns/1ps

module car_counter_tb();

localparam real CLK_PERIOD = 10;

reg t_clk, t_reset, t_carIn, t_carOut;
wire [2:0] t_counter;

car_counter cc(
    .clk(t_clk),
    .reset(t_reset),
    .carIn(t_carIn),
    .carOut(t_carOut),
    .counter(t_counter)
);

always #(CLK_PERIOD / 2) t_clk = ~ t_clk ;
initial begin
    $dumpfile("car_counter_tb.vcd");
    $dumpvars(0,car_counter_tb);

    t_clk = 1'b0;
    t_reset = 1'b0;
    t_carIn = 1'b0;
    t_carOut = 1'b0;

    # (CLK_PERIOD * 2) t_reset = 1'b1;
    # (CLK_PERIOD * 5) t_reset = 1'b0; 
    # (CLK_PERIOD * 10);
    
    repeat (8) begin 
        t_carIn = 1'b1;
        # (CLK_PERIOD * 20); 
        t_carIn = 1'b0; 
        # (CLK_PERIOD * 20); 
    end

    repeat (8) begin
        t_carOut = 1'b1; 
        # (CLK_PERIOD * 20); 
        t_carOut = 1'b0;
        # (CLK_PERIOD * 20);
    end

    t_carIn = 1'b1;
    t_carOut = 1'b1;
    # (CLK_PERIOD * 20);
    t_carIn = 1'b0;
    t_carOut = 1'b0;
    # (CLK_PERIOD * 20);

    $display("Fin de la simulación");
   $finish ;
end
endmodule