`default_nettype none
`define DUMPSTR(x) "x.vcd"
`timescale 1ns / 100ps

module debouncer_tb();

localparam real CLK_PERIOD = 1000000;
localparam real BOUNCING   = 10;
localparam BOUNCING_CYCLES = ((BOUNCING / CLK_PERIOD) * 1000000);

reg clk, rstn, sig_in;
wire sig_debounced;

debouncer Db(
    .clk(clk),
    .reset(rstn),
    .signal(sig_in),
    .debounced(sig_debounced)
);
always #(CLK_PERIOD / 2) clk = ~ clk ;
initial begin
    $dumpfile("debouncer_tb.vcd");
    $dumpvars(0,debouncer_tb);  
   clk = 1'b0;   
   rstn <= 1'b0;
   sig_in <= 1'b0;
   
   repeat (10) @(posedge clk);
   rstn <= 1'b1;    
   repeat (BOUNCING_CYCLES) @(posedge clk) sig_in <= ~ sig_in;
   sig_in <= 1'b1;
   repeat (BOUNCING_CYCLES*3) @(posedge clk);
   repeat (BOUNCING_CYCLES) @(posedge clk) sig_in <= ~ sig_in;
   sig_in <= 1'b0;
   repeat (BOUNCING_CYCLES*3) @(posedge clk); 
   repeat (BOUNCING_CYCLES) @(posedge clk) sig_in <= ~ sig_in;
   sig_in <= 1'b1;
   repeat (BOUNCING_CYCLES/2) @(posedge clk);
   repeat (BOUNCING_CYCLES) @(posedge clk) sig_in <= ~ sig_in;
   sig_in <= 1'b1;
   repeat (BOUNCING_CYCLES*3) @(posedge clk);
   repeat (BOUNCING_CYCLES) @(posedge clk) sig_in <= ~ sig_in;
   sig_in <= 1'b0;
   repeat (BOUNCING_CYCLES/2) @(posedge clk);
   repeat (BOUNCING_CYCLES) @(posedge clk) sig_in <= ~ sig_in;
   sig_in <= 1'b0;
   repeat (BOUNCING_CYCLES*3) @(posedge clk);
   $finish;
end
endmodule