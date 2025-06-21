module car_counter (
    input wire clk,
    input wire reset,
    input wire carIn,
    input wire carOut,
    output wire [2:0] counter
);
    reg [2:0] total = 3'b000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            total <= 3'b000;
        end else begin
            if (carIn && carOut) begin
                total <= total;
            end else if (carIn) begin
                if (total < 3'd7) begin
                    total <= total + 3'b001;
                end else begin
                    total <= total;
                end
            end else if (carOut) begin
                if (total > 3'd0) begin
                    total <= total - 3'b001;
                end else begin
                    total <= total;
                end
            end
        end
    end
    
    assign counter = total;
endmodule