module erase(
input clk, reset, enableDraw,
output [7:0] x_out,
output [6:0] y_out,
output [2:0] c_out,
output done,
input inEraseStateMain
);
   
reg [7:0] counterX, xOut;
reg [6:0] counterY, yOut;
reg done_;
reg [2:0] color; 
reg start;

    localparam width = 8'd159,
              height = 7'd119;
				  
    always @(posedge clk)
    begin
    if (!enableDraw || !reset) begin
    counterX<=0;
    counterY<=0;
    xOut<=0;
    yOut<=0;
    done_<= 0;
    start <=0;
    end
    else if (enableDraw && !done_ && inEraseStateMain) begin
    if (!start) begin
    start <= 1;
    counterX <= 0;
    counterY <= 0;
    xOut<=0;
    yOut<=0;
    end
    else if (start) begin
    if (counterX < width) begin counterX <= counterX + 1; end
    else if (counterX == width) begin
    counterX <= 0;
    if (counterY < height) begin
    counterY <= counterY + 1;
    end
    else if (counterY == height) begin
    done_ = 1;
    end
    end
    end
    end
    end

assign x_out = xOut + counterX;
assign y_out = yOut + counterY;
assign done = done_;
assign c_out = 3'b0;
endmodule
