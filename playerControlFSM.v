module playerControlFSM(
    clk, resetn, inputState, updateState, setAState, setDState, aPressed, dPressed
);
    input clk, resetn, aPressed, dPressed;
    output reg inputState, updateState, setAState, setDState;

    reg [1:0] current_state, next_state;
    localparam S_INPUT = 2'd0, // indicates FSM is in a state ready to accept input
               S_SET_A = 2'd1, // indicates FSM is processing right movement
               S_SET_D = 2'd2, // indicates FSM is processing right movement
               S_UPDATE_POSITION = 2'd3; // indicates player's position should be updated

    always @(*) begin
        case (current_state)
            S_INPUT: begin
                if (aPressed)
                    next_state = S_SET_A;
                else if (dPressed)
                    next_state = S_SET_D;
                else
                    next_state = S_INPUT;
            end
            S_SET_A:
                next_state = S_UPDATE_POSITION;
            S_SET_D:
                next_state = S_UPDATE_POSITION;
            S_UPDATE_POSITION:
                next_state = S_INPUT;
            default:
                next_state = S_INPUT;
        endcase
    end

    always @(*) begin
        inputState = 1'b0;
        updateState = 1'b0;
        setAState = 1'b0;
        setDState = 1'b0;

        case (current_state)
            S_INPUT:
                inputState = 1'b1;
            S_SET_A:
                setAState = 1'b1;
            S_SET_D:
                setDState = 1'b1;
            S_UPDATE_POSITION:
                updateState = 1'b1;
        endcase
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= S_INPUT;
        else
            current_state <= next_state;
    end
endmodule
