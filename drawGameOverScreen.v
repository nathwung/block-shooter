module drawGameOverScreen(clk, resetn, enableDraw, x_out, y_out, c_out);
	input clk, resetn, enableDraw;
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] c_out;
	
	localparam 	width = 8'd160;
	localparam  height = 7'd120;
   localparam	x_in = 8'b0;
	localparam  y_in = 7'b0;
    
	reg [7:0] countX, xOut;
	reg [6:0] countY, yOut;
	reg over;
	reg start;
	
    	always @(posedge clk)
    	begin
    		if (!resetn) begin
    			countX<=0;
    			countY<=0;
    			xOut<=0;
    			yOut<=0;
    			over<= 0;
    			start <=0;
    		end
    		else if (enableDraw && !over) begin
    			if (!start) begin
    				start <= 1;
    				countX <= 0;
    				countY <= 0;
    				xOut<=x_in;
    				yOut<=y_in;
    			end
    			else if (start && delay_over) begin
    				if (countX < width-1) begin countX <= countX + 1; end
    				else if (countX == width-1) begin
    					countX <= 0; 
    					if (countY < height-1) begin
    						countY <= countY + 1;
    					end
    					else if (countY == height-1) begin
    						over <= 1;
    					end
    				end
    			end
    		end
    	end
	
	reg [1:0] count2;
	reg delay_over;
	
	
	always @(posedge clk)
	begin
		if (!start) begin  delay_over <= 0; count2 <= 0; end
		else begin
			if (count2 == 0) begin delay_over <=0; count2 <= 2; end
			else if (count2 == 1) begin delay_over <= 0; count2 <= 2; end
			else if (count2 == 2) begin delay_over <= 1; count2 <= 1; end
		end
	end

	wire [2:0] color;
	wire [14:0] address;
	gameOver overScreen(
		.address(address),
		.clock(clk),
		.q(color));

	assign x_out = xOut + countX;
	assign y_out = yOut + countY;
	assign address = y_out*8'd160 + x_out;
	assign c_out = color;
endmodule
