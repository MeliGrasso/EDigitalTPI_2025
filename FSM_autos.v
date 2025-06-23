module FSM_autos (
    input wire clk,
    input wire reset,
    input wire sensor_a,
    input wire sensor_b,
    output reg carIn,
    output reg carOut
);
    reg [2:0] state, next_state;
    // 3'b000; 00 - Sensores sin bloquear(S0)
    // 3'b001; 10 - Sensor 'a' bloqueado, entra auto (SE1)
    // 3'b010; 11 - Ambos sensores bloqueados, se confirma la secuencia (SE2)
    // 3'b011; 01 - Sensor 'b' bloqueado, casi termina de entrar (SE3)

    // 3'b100; 01 - Sensor 'b' bloqueado, sale auto (SS1)
    // 3'b101; 11 - Ambos sensores bloqueados, se confirma la secuencia (SS2)
    // 3'b110; 10 - Sensor 'a' bloqueado, casi termina de salir (SS3)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'b000;
            carIn <= 1'b0;
            carOut <= 1'b0;
        end else begin
            state <= next_state;
            // Completa la secuencia.
            if (state == 3'b011 && next_state == 3'b000 && sensor_a == 1'b0 && sensor_b == 1'b0) begin
                carIn <= 1'b1;
            end else begin
                carIn <= 1'b0;
            end
            if (state == 3'b110 && next_state == 3'b000 && sensor_a == 1'b0 && sensor_b == 1'b0) begin
                carOut <= 1'b1;
            end else begin
                carOut <= 1'b0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case(state)
            3'b000: begin // Sensor con ambas luces libres. 00
                if(sensor_a == 1'b1 && sensor_b == 1'b0) begin
                    next_state = 3'b001; // Principio de una entrada
                end else if (sensor_a == 1'b0 && sensor_b == 1'b1) begin
                    next_state = 3'b100; // Principio de una salida
                end
            end
            3'b001: begin // Sensor 'a' bloqueado. 10
                if (sensor_a == 1'b1 && sensor_b == 1'b1) begin
                    next_state = 3'b010;
                end else if (sensor_a == 1'b0 && sensor_b == 1'b0) begin
                    next_state = 3'b000;
                end else if (sensor_a == 1'b1 && sensor_b == 1'b0) begin
                    next_state = 3'b001;
                end else if (sensor_a == 1'b0 && sensor_b == 1'b1) begin
                    next_state = 3'b000;
                end
            end
            3'b010: begin // Ambos sensores bloqueados POR UN VEHÍCULO
                if (sensor_a == 1'b0 && sensor_b == 1'b1) begin 
                    next_state = 3'b011; 
                end else if (sensor_a == 1'b1 && sensor_b == 1'b0) begin
                    next_state = 3'b001;
                end else if (sensor_a == 1'b0 && sensor_b == 1'b0) begin
                    next_state = 3'b000;
                end
            end
            3'b011: begin // sensor 'b' bloqueado
                if (sensor_a == 1'b0 && sensor_b == 1'b0) begin
                    next_state = 3'b000;
                end else if (sensor_a == 1'b1 && sensor_b == 1'b1) begin
                    next_state = 3'b010;
                end else if (sensor_a == 1'b1 && sensor_b == 1'b0) begin
                    next_state = 3'b001;
                end
            end
            3'b100: begin
                if (sensor_a == 1'b1 && sensor_b == 1'b1) begin 
                    next_state = 3'b101; 
                end else if (sensor_a == 1'b0 && sensor_b == 1'b0) begin
                    next_state = 3'b000;
                end else if (sensor_a == 1'b0 && sensor_b == 1'b1) begin
                    next_state = 3'b100;
                end else if (sensor_a == 1'b1 && sensor_b == 1'b0) begin
                    next_state = 3'b100;
                end
            end
            3'b101: begin
                if (sensor_a == 1'b1 && sensor_b == 1'b0) begin 
                    next_state = 3'b110; 
                end else if (sensor_a == 1'b0 && sensor_b == 1'b1) begin
                    next_state = 3'b100;
                end else if (sensor_a == 1'b0 && sensor_b == 1'b0) begin
                    next_state = 3'b000;
                end
            end
            3'b110: begin
               if (sensor_a == 1'b0 && sensor_b == 1'b0) begin 
                    next_state = 3'b000; // Auto fuera/adentro
                end else if (sensor_a == 1'b1 && sensor_b == 1'b1) begin
                    next_state = 3'b101;
                end else if (sensor_a == 1'b0 && sensor_b == 1'b1) begin
                    next_state = 3'b100;
                end
            end
            default: begin
                next_state = 3'b000;
            end
        endcase
    end
endmodule