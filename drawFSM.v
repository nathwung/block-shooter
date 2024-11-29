module drawFSM(clk, resetn, objectToDraw, vgaPlot, doneDrawing, doneErasing, inEraseState, inUpdatePositionState, inDrawGameoverScreenState, inDrawStartScreenState, spacePressed, playerHealth);
input clk, resetn, doneDrawing, doneErasing, spacePressed;
input [3:0] playerHealth;
output [3:0] objectToDraw;
output vgaPlot;
output reg inEraseState, inUpdatePositionState, inDrawGameoverScreenState, inDrawStartScreenState;

reg [3:0] drawSignalOut;
reg [5:0] current_state, next_state;
reg vgaPlotOut;
reg [3:0] frameCounter;
reg [26:0] rateDividerCounter;

localparam S_ERASE = 6'd1,
 S_DRAW_PLAYER = 6'd2,
 S_DRAW_BULLET = 6'd3,
 S_DRAW_ENEMY1 = 6'd4,
 S_DRAW_ENEMY2 = 6'd5,
 S_DRAW_ENEMY3 = 6'd6,
 S_DRAW_ENEMY4 = 6'd7,
 S_WAIT1 = 6'd8,
 S_WAIT2 = 6'd9,
 S_WAIT3 = 6'd10,
 S_WAIT4 = 6'd11,
 S_WAIT5 = 6'd12,
 S_WAIT6 = 6'd13,
 S_WAIT7 = 6'd14,
 S_WAIT8 = 6'd15,
 S_WAIT9 = 6'd16,
 S_WAIT10 = 6'd17,
 S_WAIT11 = 6'd18,
 S_WAIT12 = 6'd19,
 S_WAIT13 = 6'd20,
 S_WAIT14 = 6'd21,
 S_RESET_FRAMES = 6'd22,
 S_DELAY_UPDATE = 6'd23,
 S_UPDATE_POSITION = 6'd24,
 S_DRAW_START_SCREEN = 6'd25,
 S_DRAW_GAMEOVER_SCREEN = 6'd26;

	 always @(*) begin
    // Default next state assignment
    next_state = S_DRAW_PLAYER;

    if (current_state == S_DRAW_START_SCREEN) begin
        if (spacePressed) 
            next_state = S_ERASE;
        else 
            next_state = S_DRAW_START_SCREEN;
    end
    else if (current_state == S_DRAW_GAMEOVER_SCREEN) begin
        if (spacePressed) 
            next_state = S_DRAW_START_SCREEN;
        else 
            next_state = S_DRAW_GAMEOVER_SCREEN;
    end
    else if (current_state == S_ERASE) begin
        if (doneErasing) 
            next_state = S_DRAW_PLAYER;
        else 
            next_state = S_ERASE;
    end
    else if (current_state == S_DRAW_PLAYER) begin
        if (doneDrawing) 
            next_state = S_WAIT1;
        else 
            next_state = S_DRAW_PLAYER;
    end
    else if (current_state == S_WAIT1) begin
        next_state = S_DRAW_BULLET;
    end
    else if (current_state == S_DRAW_BULLET) begin
        if (doneDrawing) 
            next_state = S_WAIT6;
        else 
            next_state = S_DRAW_BULLET;
    end
    else if (current_state == S_WAIT6) begin
        next_state = S_DRAW_ENEMY1;
    end
    else if (current_state == S_DRAW_ENEMY1) begin
        if (doneDrawing) 
            next_state = S_WAIT2;
        else 
            next_state = S_DRAW_ENEMY1;
    end
    else if (current_state == S_WAIT2) begin
        next_state = S_DRAW_ENEMY2;
    end
    else if (current_state == S_DRAW_ENEMY2) begin
        if (doneDrawing) 
            next_state = S_WAIT3;
        else 
            next_state = S_DRAW_ENEMY2;
    end
    else if (current_state == S_WAIT3) begin
        next_state = S_DRAW_ENEMY3;
    end
    else if (current_state == S_DRAW_ENEMY3) begin
        if (doneDrawing) 
            next_state = S_WAIT4;
        else 
            next_state = S_DRAW_ENEMY3;
    end
    else if (current_state == S_WAIT4) begin
        next_state = S_DRAW_ENEMY4;
    end
    else if (current_state == S_DRAW_ENEMY4) begin
        if (doneDrawing) 
            next_state = S_WAIT5;
        else 
            next_state = S_DRAW_ENEMY4;
    end
    else if (current_state == S_WAIT5) begin
        next_state = S_RESET_FRAMES;
    end
    else if (current_state == S_RESET_FRAMES) begin
        next_state = S_DELAY_UPDATE;
    end
    else if (current_state == S_DELAY_UPDATE) begin
        if (frameCounter == 4'd3) 
            next_state = S_UPDATE_POSITION;
        else 
            next_state = S_DELAY_UPDATE;
    end
    else if (current_state == S_UPDATE_POSITION) begin
        if (playerHealth >= 1) 
            next_state = S_ERASE;
        else 
            next_state = S_DRAW_GAMEOVER_SCREEN;
    end
end

    always @(*)
    begin: enable_signals
        drawSignalOut <= 4'b0;
 vgaPlotOut <= 1'b0;
 inEraseState <= 0;
 inUpdatePositionState <= 0;
 inDrawStartScreenState <= 0;
 inDrawGameoverScreenState <= 0;
 
        case (current_state)
S_ERASE: begin inEraseState <= 1; vgaPlotOut <= 1; end
S_DRAW_START_SCREEN: begin inDrawStartScreenState <= 1; vgaPlotOut <= 1; end
S_DRAW_GAMEOVER_SCREEN: begin inDrawGameoverScreenState <= 1; vgaPlotOut <= 1; end
S_DELAY_UPDATE: begin vgaPlotOut <= 0; end
S_UPDATE_POSITION: begin inUpdatePositionState <= 1; vgaPlotOut <= 0; end
S_RESET_FRAMES: begin vgaPlotOut <= 0; end

S_DRAW_PLAYER: begin
drawSignalOut <= 4'd1;
vgaPlotOut <= 1;
end

S_DRAW_ENEMY1: begin
drawSignalOut <= 4'd2;
vgaPlotOut <= 1;
end

S_DRAW_ENEMY2: begin
drawSignalOut <= 4'd3;
vgaPlotOut <= 1;
end

S_DRAW_ENEMY3: begin
drawSignalOut <= 4'd4;
vgaPlotOut <= 1;
end

S_DRAW_ENEMY4: begin
drawSignalOut <= 4'd5;
vgaPlotOut <= 1;
end

S_DRAW_BULLET: begin
drawSignalOut <= 4'd6;
vgaPlotOut <= 1;
end


S_WAIT1: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT2: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT3: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT4: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT5: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT6: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT7: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

S_WAIT8: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end
S_WAIT9: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end
S_WAIT10: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end
S_WAIT11: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end
S_WAIT12: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end
S_WAIT13: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end
S_WAIT14: begin
vgaPlotOut <= 0;
drawSignalOut <= 0;
end

        endcase
    end

    always@(posedge clk)
    begin: state_FFs
        if (resetn == 1'b0) begin
            current_state <= S_DRAW_START_SCREEN;
frameCounter <= 0;
rateDividerCounter <= 27'd833333;
        end
        else begin
            current_state <= next_state;

if (current_state == S_RESET_FRAMES) begin
rateDividerCounter <= 27'd833333;
frameCounter <= 4'b0;
end
else if(current_state == S_DELAY_UPDATE) begin
if (rateDividerCounter == 0) begin
frameCounter <= frameCounter + 1'b1;
rateDividerCounter <= 27'd833333;

if (frameCounter == 4'd3)
frameCounter <= 0;
else
frameCounter <= frameCounter + 1'b1;
end
else
rateDividerCounter <= rateDividerCounter - 1'b1;
end
end
    end

    assign objectToDraw = drawSignalOut;
assign vgaPlot = vgaPlotOut;
endmodule
