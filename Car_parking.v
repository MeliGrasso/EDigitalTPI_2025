module Car_parking (
    input wire clk,
    input wire reset,
    input wire a_btn,
    input wire b_btn,
    output wire [2:0] led_counter
);
    wire inv_reset_btn, inv_a_btn, inv_b_btn;
    //assign inv_reset_btn = ~reset; // Para el test_bench dejar esto comentado.
    assign inv_reset_btn = reset; // Para la FPGA dejar esto comentado.
    assign inv_a_btn = ~a_btn;
    assign inv_b_btn = ~b_btn;

// Debounce buttons
    wire deb_a, deb_b;
    debouncer d_sa(
        .clk(clk),
        .reset(inv_reset_btn),
        .signal(inv_a_btn),
        .debounced(deb_a)
    );
    debouncer d_sb(
        .clk(clk),
        .reset(inv_reset_btn),
        .signal(inv_b_btn),
        .debounced(deb_b)
    );
// FSM
    wire signal_carIn, signal_carOut;
    FSM_autos MEF(
        .clk(clk),
        .reset(inv_reset_btn),
        .sensor_a(deb_a),
        .sensor_b(deb_b),
        .carIn(signal_carIn),
        .carOut(signal_carOut)
    );
// Car counter
    car_counter counter(
        .clk(clk),
        .reset(inv_reset_btn),
        .carIn(signal_carIn),
        .carOut(signal_carOut),
        .counter(led_counter)
    );
endmodule