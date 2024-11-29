module playerPositionHandler(
    input clk, resetn, inputState, updateState, setAState, setDState,
    output [7:0] x_current,
    output [6:0] y_current,
    input keyboardAPressed, keyboardDPressed
);
    reg [7:0] current_x; // current x-coordinate of player
    reg aPressed, dPressed;
    reg kPressed; // flag to prevent continuous movement for a single press

    localparam x1 = 8'd14,
               x2 = 8'd54,
               x3 = 8'd94,
               x4 = 8'd134,
               y  = 7'd99;

    always @(posedge clk) begin
        if (!resetn) begin
            current_x <= x1;
            aPressed <= 1'b0;
            dPressed <= 1'b0;
            kPressed <= 1'b0;
        end else if (setAState) begin
            aPressed <= 1'b1;
            dPressed <= 1'b0;
        end else if (setDState) begin
            aPressed <= 1'b0;
            dPressed <= 1'b1;
        end else if (updateState) begin
            if (aPressed && !kPressed) begin
                case (x_current)
                    x1: current_x <= x1;
                    x2: current_x <= x1;
                    x3: current_x <= x2;
                    x4: current_x <= x3;
                    default: current_x <= x1;
                endcase
                aPressed <= 1'b0;
                kPressed <= 1'b1;
            end else if (dPressed && !kPressed) begin
                case (x_current)
                    x1: current_x <= x2;
                    x2: current_x <= x3;
                    x3: current_x <= x4;
                    x4: current_x <= x4;
                    default: current_x <= x1;
                endcase
                dPressed <= 1'b0;
                kPressed <= 1'b1;
            end
        end else if (keyboardAPressed == 1'b0 && keyboardDPressed == 1'b0) begin
            kPressed <= 1'b0; // flag is cleared, allows player block to respond to new key presses
            aPressed <= 1'b0;
            dPressed <= 1'b0;
        end
    end

    assign x_current = current_x;
    assign y_current = y;
endmodule
