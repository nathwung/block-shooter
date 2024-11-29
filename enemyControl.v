module enemyControl(clk, resetn, enable, updatePosition, bottomReached, inResetState, inUpdatePositionStateE, collidedWithBullet, collidedWithPlayer, maximumHealth, currentHealth, score);
input clk, resetn, enable, updatePosition, bottomReached, collidedWithBullet, collidedWithPlayer;
output reg [2:0] maximumHealth;
output reg [2:0] currentHealth;
output reg inResetState, inUpdatePositionStateE; 
reg [3:0] current_state, next_state;
input [7:0] score;
wire [23:0] randOut;
wire randDone;
wire [23:0] delayInSeconds;
reg generateDelay;
reg [3:0] delay;
reg [31:0] delayCounter;

   localparam  S_RESET        = 4'd0,
               S_UPDATE_POSITION      = 4'd1,
               S_WAIT                 = 4'd2,
					S_GENERATE_DELAY = 4'd3; // uses LFSR to generate randomized delay in enemy spawning
	 always @(*)
begin: state_table
    // Default state
    next_state = S_RESET;

    if (current_state == S_RESET) begin
        if (delay == 0)
            next_state = S_UPDATE_POSITION;
        else
            next_state = S_RESET;
    end else if (current_state == S_UPDATE_POSITION) begin
        if (bottomReached || collidedWithPlayer || (currentHealth == 0))
            next_state = S_GENERATE_DELAY;
        else
            next_state = S_WAIT;
    end else if (current_state == S_WAIT) begin
        if (updatePosition)
            next_state = S_UPDATE_POSITION;
        else
            next_state = S_WAIT;
    end else if (current_state == S_GENERATE_DELAY) begin
        next_state = S_RESET;
    end
end

    always @(*)
    begin: enable_signals
        inResetState <= 1'b0;
		  inUpdatePositionStateE <= 0;
		  generateDelay <= 0;
 
        case (current_state)
            S_RESET: inResetState <= 1'b1;
				S_UPDATE_POSITION: inUpdatePositionStateE <= 1;
				S_GENERATE_DELAY: generateDelay <= 1;
        endcase
    end 

    always@(posedge clk)
    begin: state_FFs
        if(!resetn) begin
            current_state <= S_RESET;
				delayCounter <= 32'd25000000;
				delay <= 4'd1;
				maximumHealth <= 3'd1;
				currentHealth <= maximumHealth;
	 end
	 else begin
	 if (generateDelay)
	 delay <= delayInSeconds[3:0];
	 if (current_state == S_RESET) begin
		maximumHealth <= 3'd1;
		if(currentHealth <= 0)
		currentHealth <= maximumHealth;

		if (delayCounter > 0)
		delayCounter <= delayCounter - 1;
		else begin
		delayCounter <= 32'd25000000;

		if (delay > 0)
		delay <= delay - 1;
		else
		delay <= 4'd1;
	 end
end

if(updatePosition && (collidedWithBullet) && currentHealth > 0 && current_state != S_RESET)
currentHealth <= currentHealth - 1;

current_state <= next_state;
if(currentHealth <= 0)
currentHealth <= maximumHealth;

end
    end

LFSR #(.NUM_BITS(24)) randomNumGenerator(clk, generateDelay, 0, 0, randOut, randDone);
assign delayInSeconds = ({randOut} % 4) + 1;
endmodule
