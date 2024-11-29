module main(
input CLOCK_50,
input [3:0] KEY,
inout PS2_CLK, PS2_DAT,
output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
output [9:0] VGA_R, VGA_G, VGA_B,
output [6:0] HEX0, HEX1, HEX2
);

wire clk, resetn;
assign clk = CLOCK_50;

// KEY[0] to reset game
assign resetn = KEY[0];

// keyboard
wire a, d, space;
wire aPressed, dPressed, spacePressed;

// coordinates of player
wire [7:0] player_X;
wire [6:0] player_Y;

// collision detection signals
wire pEC1, pEC2, pEC3, pEC4; // player to enemy
wire bEC1, bEC2, bEC3, bEC4; // bullet to enemy

// health and score of player
wire [3:0] health;
wire [7:0] score;

// FSM control signals
wire inputState; // accepts input from player
wire updateState; // update position of player

// FSM control signals
wire A_State; // handle input "A"
wire D_State; // handle input "D"

wire vgaPlot, doneDrawing, doneErasing;
wire [3:0] objectToDraw;
wire [7:0] drawX;
wire [6:0] drawY;
wire [2:0] drawColour;
wire [4:0] drawWidth, drawHeight;
wire inEraseStateMain, inUpdatePositionStateMain, inDrawGameoverScreenState, inDrawStartScreenState;
wire [7:0] eraseX, xDraw;
wire [6:0] eraseY, yDraw;
wire [2:0] eraseColour, colourDraw;
wire [7:0] vgaX;
wire [6:0] vgaY;
wire [2:0] vgaColour;

wire bottomReachedE1, inResetStateE1, inUpdatePositionStateE1, bottomReachedE2, inResetStateE2, inUpdatePositionStateE2,
bottomReachedE3, inResetStateE3, inUpdatePositionStateE3, bottomReachedE4, inResetStateE4, inUpdatePositionStateE4;
wire [7:0] enemyX1, enemyX2, enemyX3, enemyX4;
wire [6:0] enemyY1, enemyY2, enemyY3, enemyY4;
wire [2:0] enemyColour1, enemyColour2, enemyColour3, enemyColour4, enemyColourIn1, enemyColourIn2, enemyColourIn3, enemyColourIn4;
wire [3:0] enemySpeed1, enemySpeed2, enemySpeed3, enemySpeed4;
wire [2:0] enemyHealthCurr1, enemyHealthCurr2, enemyHealthCurr3, enemyHealthCurr4;
wire [2:0] enemyHealthMax1, enemyHealthMax2, enemyHealthMax3, enemyHealthMax4;

wire inResetStateB1, inUpdatePositionStateB1, inWaitStateB1, topReachedB1;
wire [7:0] bulletX1;
wire [6:0] bulletY1;
wire activeB;

// player 
playerControlFSM controlPlayer(clk, resetn, inputState, updateState, A_State, D_State, aPressed, dPressed);
playerPositionHandler ppositionHandler(clk, resetn, inputState, updateState, A_State, D_State, player_X, player_Y, aPressed, dPressed);

// enemies
enemyControl controlEnemy1(clk, resetn, 1'b1, inUpdatePositionStateMain, bottomReachedE1, inResetStateE1, inUpdatePositionStateE1, bEC1, pEC1, enemyHealthMax1, enemyHealthCurr1, score);
enemyPositionHandler epositionHandler1(clk, inResetStateE1, inUpdatePositionStateMain, 8'd14, enemyX1, enemyY1, bottomReachedE1, 4'd2, enemySpeed1, resetn, enemyColour1, score);
enemyControl ControlEnemy2(clk, resetn, 1'b1, inUpdatePositionStateMain, bottomReachedE2, inResetStateE2, inUpdatePositionStateE2, bEC2, pEC2, enemyHealthMax2, enemyHealthCurr2, score);
enemyPositionHandler epositionHandler2(clk, inResetStateE2, inUpdatePositionStateMain, 8'd54, enemyX2, enemyY2, bottomReachedE2, 4'd3, enemySpeed2, resetn, enemyColour2, score);
enemyControl controlEnemy3(clk, resetn, 1'b1, inUpdatePositionStateMain, bottomReachedE3, inResetStateE3, inUpdatePositionStateE3, bEC3, pEC3, enemyHealthMax3, enemyHealthCurr3, score);
enemyPositionHandler epositionHandler3(clk, inResetStateE3, inUpdatePositionStateMain, 8'd94, enemyX3, enemyY3, bottomReachedE3, 4'd4, enemySpeed3, resetn, enemyColour3, score);
enemyControl controlEnemy4(clk, resetn, 1'b1, inUpdatePositionStateMain, bottomReachedE4, inResetStateE4, inUpdatePositionStateE4, bEC4, pEC4, enemyHealthMax4, enemyHealthCurr4, score);
enemyPositionHandler epositionHandler4(clk, inResetStateE4, inUpdatePositionStateMain, 8'd134, enemyX4, enemyY4, bottomReachedE4, 4'd1, enemySpeed4, resetn, enemyColour4, score);

//bullet
bulletControl controlBullet(clk, resetn, inResetStateB1, inUpdatePositionStateB1, inWaitStateB1, spacePressed, inUpdatePositionStateMain, topReachedB1, (bEC1 || bEC2 || bEC3 || bEC4));
bulletPositionHandler bpositionHandler(clk, inResetStateB1, inUpdatePositionStateB1, inWaitStateB1, player_X + 3'd3, bulletX1, bulletY1, topReachedB1, activeB);

//drawing
drawFSM drawFSMModule(clk, resetn, objectToDraw, vgaPlot, doneDrawing, doneErasing, inEraseStateMain, inUpdatePositionStateMain, inDrawGameoverScreenState, inDrawStartScreenState, spacePressed, health);
displayHandler handleDisplay(player_X, enemyX1, enemyX2, enemyX3, enemyX4, bulletX1, player_Y, enemyY1, enemyY2, enemyY3, enemyY4, bulletY1,
 5'd10, 5'd10, 5'd10, 5'd10, 5'd4, 5'd4, 3'b111, enemyColour1, enemyColour2, enemyColour3, enemyColour4, 3'b111, clk, resetn, objectToDraw,
 drawX, drawY, drawColour, drawWidth, drawHeight, pEC1, pEC2, pEC3, pEC4, bEC1,
 bEC2, bEC3, bEC4, activeB);
 
draw drawModule(drawX, drawY, drawWidth, drawHeight, drawColour, clk, resetn, vgaPlot, xDraw, yDraw, colourDraw, doneDrawing, inEraseStateMain);
erase eraseModule(clk, resetn, vgaPlot, eraseX, eraseY, eraseColour, doneErasing, inEraseStateMain);

// keyboard
keyboard_tracker #(.PULSE_OR_HOLD(0)) tester(
    .clock(clk),
	 .reset(resetn),
	 .PS2_CLK(PS2_CLK),
	 .PS2_DAT(PS2_DAT),
	 .a(aPressed),
	 .d(dPressed),
	 .space(spacePressed)
);

// vga
vga_adapter VGA(
.resetn(resetn),
.clock(clk),
.colour(vgaColour),
.x(vgaX),
.y(vgaY),
.plot(vgaPlot),
.VGA_R(VGA_R),
.VGA_G(VGA_G),
.VGA_B(VGA_B),
.VGA_HS(VGA_HS),
.VGA_VS(VGA_VS),
.VGA_BLANK_N(VGA_BLANK_N),
.VGA_SYNC_N(VGA_SYNC_N),
.VGA_CLK(VGA_CLK));
defparam VGA.RESOLUTION = "160x120";
defparam VGA.MONOCHROME = "FALSE";
defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
defparam VGA.BACKGROUND_IMAGE = "black.mif";

// score and health of player
updateScore scoreUpdate(clk, resetn, ((bEC1 && !inResetStateE1) || (beCollision2 && !inResetStateE2) || (bEC3 && !inResetStateE3) || (bEC4 && !inResetStateE4)), HEX0, HEX1, inUpdatePositionStateMain, score);
updateHealth healthUpdate(clk, resetn, (pEC1 || pEC2 || pEC3 || pEC4), HEX2, inUpdatePositionStateMain, health, inDrawGameoverScreenState);

reg [7:0] vgaXOut;
reg [6:0] vgaYOut;
reg [2:0] vgaColourOut;
wire [7:0] startScreenX, gameOScreenX;
wire [6:0] startScreenY, gameOScreenY;
wire [2:0] startScreenColour, gameOScreenColour;

drawStartGameScreen startScreen(clk, resetn, inDrawStartScreenState, startScreenX, startScreenY, startScreenColour);
drawGameOverScreen gameOverScreen(clk, resetn, inDrawGameoverScreenState, gameOScreenX, gameOScreenY, gameOScreenColour);

always @(*)
begin
case (inEraseStateMain)
1'b1: begin vgaXOut = eraseX; vgaYOut = eraseY; vgaColourOut = colourDraw; end
1'b0: begin
case (inDrawGameoverScreenState)
1'b1: begin vgaXOut = gameOScreenX; vgaYOut = gameOScreenY; vgaColourOut = gameOScreenColour; end
1'b0: begin
case (inDrawStartScreenState)
1'b1: begin vgaXOut = startScreenX; vgaYOut = startScreenY; vgaColourOut = startScreenColour; end
1'b0: begin vgaXOut = xDraw; vgaYOut = yDraw; vgaColourOut <= colourDraw; end
endcase
end
endcase
end
endcase
end

assign vgaX = vgaXOut;
assign vgaY = vgaYOut;
assign vgaColour = vgaColourOut;
endmodule
