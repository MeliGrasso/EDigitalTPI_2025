`default_nettype none
`define DUMPSTR(x) "x.vcd"
`timescale 1ns/1ps
// timescale <time_unit> / <time_precision>

module Car_parking_tb();
// simulation time: 1us (10 * 100ns)
parameter DURATION = 100;

reg clk = 0;
always #5 clk = ~clk;

reg t_reset, t_a, t_b;
wire [2:0] t_out;

Car_parking UUT(
    .clk(clk),
    .reset(t_reset),
    .a_btn(t_a),
    .b_btn(t_b),
    .led_counter(t_out)
);

initial begin
    $dumpfile("Car_parking_tb.vcd");
    $dumpvars(0,Car_parking_tb);  
    
    $display("----------------------------------------");
    $display("End sim");
    $finish;
end
endmodule