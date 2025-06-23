`default_nettype none
`define DUMPSTR(x) "x.vcd"
`timescale 1ns/1ps
// timescale <time_unit> / <time_precision>

module Car_parking_tb();
// simulation time: 1us (10 * 100ns)
parameter CLK_PERIOD = 10;
parameter DELAY = CLK_PERIOD * (600_000); // Teniendo en cuenta el debouncer threshold

reg clk = 0;
always #((CLK_PERIOD / 2)) clk = ~clk;

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
    clk = 1'b0;
    t_reset = 1'b1;
    t_a = 1'b1;
    t_b = 1'b1;

    #(CLK_PERIOD * 5);
    t_reset = 1'b0;
    #(DELAY);

    // 1. Entrada de un auto (secuencia completa y válida)
    #(CLK_PERIOD * 10);
    t_a = 1'b0; t_b = 1'b1;
    #(DELAY);
    t_a = 1'b0; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);
    
    // 2. Salida de un auto (secuencia completa y válida)
    #(CLK_PERIOD * 50);
    t_a = 1'b1; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b0; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b0; t_b = 1'b1;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);

    // 3. Peatón que empieza a entrar y se arrepiente (10 -> 00)
    #(CLK_PERIOD * 50);
    t_a = 1'b0; t_b = 1'b1;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);

    // 4. Peatón que empieza a salir y se arrepiente (01 -> 00)
    #(CLK_PERIOD * 50);
    t_a = 1'b1; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);

    // 5. Auto "se arrepiente" en medio de la entrada (10 -> 11 -> 10)
    #(CLK_PERIOD * 50);
    t_a = 1'b0; t_b = 1'b1;
    #(DELAY);
    t_a = 1'b0; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b0; t_b = 1'b1;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);

    // 6. Auto "se arrepiente" en medio de la salida (01 -> 11 -> 01)
    #(CLK_PERIOD * 50);
    t_a = 1'b1; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b0; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);

    // 7. Evento anómalo (directo a 11 desde 00)
    #(CLK_PERIOD * 50);
    t_a = 1'b0; t_b = 1'b0;
    #(DELAY);
    t_a = 1'b1; t_b = 1'b1;
    #(DELAY);

    repeat (7) begin
        #(CLK_PERIOD * 50);
        t_a = 1'b0; t_b = 1'b1;
        #(DELAY);
        t_a = 1'b0; t_b = 1'b0; 
        #(DELAY);
        t_a = 1'b1; t_b = 1'b0;
        #(DELAY);
        t_a = 1'b1; t_b = 1'b1;
        #(DELAY);
    end

    $display("----------------------------------------");
    $display("End sim");
    $finish;
end
endmodule