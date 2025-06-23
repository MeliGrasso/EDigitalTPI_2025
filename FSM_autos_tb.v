`default_nettype none
`define DUMPSTR(x) "x.vcd"
`timescale 1ns/1ps
// timescale <time_unit> / <time_precision>

module FSM_autos_tb();
// simulation time: 1us (10 * 100ns)
parameter DURATION = 100;

reg clk = 0;
always #5 clk = ~clk;

reg t_reset, t_a, t_b;
wire t_in, t_out;

FSM_autos UUT(
    .clk(clk),
    .reset(t_reset),
    .sensor_a(t_a),
    .sensor_b(t_b),
    .carIn(t_in),
    .carOut(t_out)
);

initial begin
    $dumpfile("FSM_autos_tb.vcd");
    $dumpvars(0,FSM_autos_tb);  
    clk = 1'b0;
    t_reset = 1'b1;
    t_a = 1'b0;
    t_b = 1'b0;
    #10;
    $display("----------------------------------------");
    $display("Testbench");
    $display("----------------------------------------");
   
    t_reset = 0;
    #10;
    
    // 2. Entrada de un auto (secuencia completa y válida)
    @(posedge clk) t_a = 1'b1; t_b = 1'b0;
    @(posedge clk) t_a = 1'b1; t_b = 1'b1;
    @(posedge clk) t_a = 1'b0; t_b = 1'b1;
    @(posedge clk) t_a = 1'b0; t_b = 1'b0;
    #20;
    // 3. Salida de un auto (secuencia completa y válida)
    @(posedge clk) t_a = 1'b0; t_b = 1'b1; 
    @(posedge clk) t_a = 1'b1; t_b = 1'b1;
    @(posedge clk) t_a = 1'b1; t_b = 1'b0;
    @(posedge clk) t_a = 1'b0; t_b = 1'b0;
    #20;
    // 4. Peatón que empieza a entrar y se arrepiente (10 -> 00)
    @(posedge clk) t_a = 1'b1; t_b = 1'b0; 
    @(posedge clk) t_a = 1'b0; t_b = 1'b0; 
    #20;
    // 5. Peatón que empieza a salir y se arrepiente (01 -> 00)
    @(posedge clk) t_a = 1'b0; t_b = 1'b1;
    @(posedge clk) t_a = 1'b0; t_b = 1'b0; 
    #20;
    // 6. Auto "se arrepiente" en medio de la entrada (10 -> 11 -> 10)
    @(posedge clk) t_a = 1'b1; t_b = 1'b0; 
    @(posedge clk) t_a = 1'b1; t_b = 1'b1;
    @(posedge clk) t_a = 1'b1; t_b = 1'b0;
    #20;
    // 7. Auto "se arrepiente" en medio de la salida (01 -> 11 -> 01)
    @(posedge clk) t_a = 1'b0; t_b = 1'b1;
    @(posedge clk) t_a = 1'b1; t_b = 1'b1;
    @(posedge clk) t_a = 1'b0; t_b = 1'b1;
    #20;
    // 8. Evento anómalo (directo a 11 desde 00)
    @(posedge clk) t_a = 1'b1; t_b = 1'b1; 
    @(posedge clk) t_a = 1'b0; t_b = 1'b0; 
#DURATION;
$display("----------------------------------------");
$display("End sim");
$finish;
end
endmodule