module FFD(
    input wire clk, d,
    input wire reset,
    input wire set,
    input wire enable,
    output wire Q,Qn
); 
reg salida = 0;
//Con reset y set asíncronos (no depende del reloj) (por eso el or en el always)
always @ (posedge clk or posedge reset or posedge set) begin
    if (reset)
        salida <= 0; //Si activo el reset, todo se va a cero.
    else if (set)
        salida <= 1;
    else if(enable)
        salida <= d;
end
    assign Q = salida;
    assign Qn = ~Q;
endmodule
