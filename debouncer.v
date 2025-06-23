module debouncer (
    input wire clk,
    input wire reset,
    input wire signal,
    output wire debounced
);  
   localparam DEBOUNCE_THRESHOLD = 20'd600_000; // Tiempo que la señal debe ser estable.
   localparam COUNTER_WIDTH = $clog2(DEBOUNCE_THRESHOLD + 1); // Nro de bits (N) para representar el contador

   reg firstSignal_sync = 1'b0;
   reg secondSignal_sync = 1'b0;
   reg [COUNTER_WIDTH-1:0] counter = {COUNTER_WIDTH{1'b0}};
   reg sig_debounced = 1'b0; // Señal estable

   always @(posedge clk or posedge reset) begin
        if (reset) begin
            firstSignal_sync <= 1'b0;
            secondSignal_sync <= 1'b0;
            counter <= {COUNTER_WIDTH{1'b0}};
            sig_debounced <= 1'b0;
        end else begin
            firstSignal_sync <= signal;
            secondSignal_sync <= firstSignal_sync; // Sincroniza
            if (secondSignal_sync != sig_debounced) begin // Debouncing. Potencial cambio entre la señal sincronizada y la estable.
                if (counter < DEBOUNCE_THRESHOLD) begin
                    counter <= counter + 1; // 
                end else begin // La señal sincronizada secondSignal_sync ha estado estable por un tiempo (debounce threshold).
                    sig_debounced <= secondSignal_sync;
                    counter <= {COUNTER_WIDTH{1'b0}}; // Contador se resetea
                end
            end else begin // No hay transición porque la señal que llegó es estable.
               counter <= {COUNTER_WIDTH{1'b0}};
            end
        end
    end
    assign debounced = sig_debounced;

endmodule