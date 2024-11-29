module bulletControl(
    clk,
    resetn,
    inResetState,
    inUpdatePositionState,
    inWaitState,
    spacePressed,
    updatePosition,
    topReached,
    collidedWithEnemy
);
    input clk, resetn, updatePosition, topReached, spacePressed, collidedWithEnemy;
    output reg inResetState, inUpdatePositionState, inWaitState; 

    reg [3:0] current_state, next_state;
    localparam S_RESET = 4'b0000,               
               S_UPDATE_POSITION = 4'b0001,
               S_WAIT = 4'b0010; 
					
    always @(*) begin
        case (current_state)
            S_RESET: 
                if (spacePressed)
                    next_state = S_UPDATE_POSITION;
                else
                    next_state = S_RESET;
            S_UPDATE_POSITION: 
                if (topReached || collidedWithEnemy)
                    next_state = S_RESET;
                else
                    next_state = S_WAIT;
            S_WAIT: 
                if (updatePosition)
                    next_state = S_UPDATE_POSITION;
                else
                    next_state = S_WAIT;
            default: 
                next_state = S_RESET;
        endcase
    end

    always @(*) begin
        inResetState = 1'b0;
        inUpdatePositionState = 1'b0;
        inWaitState = 1'b0;

        case (current_state)
            S_RESET: 
                inResetState = 1'b1;
            S_UPDATE_POSITION: 
                inUpdatePositionState = 1'b1;
            S_WAIT: 
                inWaitState = 1'b1;
        endcase
    end

    always @(posedge clk or negedge resetn) begin
        if (!resetn)
            current_state <= S_RESET; 
        else
            current_state <= next_state; 
    end
endmodule
