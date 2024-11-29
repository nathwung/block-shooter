module drawStartGameScreen(clk, resetn, enableDraw, x_out, y_out, c_out);
input clk, resetn, enableDraw;
output [7:0] x_out;
output [6:0] y_out;
output [2:0] c_out;

localparam width = 8'd160,
height = 7'd120,
x_in = 8'b0,
y_in = 7'b0;
   
reg [7:0] counterX, xOut; 
reg [6:0] counterY, yOut; 
reg done_;
reg start;

    always @(posedge clk)
    begin
    if (!resetn) begin 
    counterX<=0; 
    counterY<=0;
    xOut<=0; 
    yOut<=0;
    done_<= 0;
    start <=0;
    end
    else if (enableDraw && !done_) begin
    if (!start) begin
    start <= 1;
    counterX <= 0;
    counterY <= 0;
    xOut<=x_in;
    yOut<=y_in;
    end
    else if (start && delay_over) begin
    if (counterX < width-1) begin counterX <= counterX + 1; end
    else if (counterX == width-1) begin
    counterX <= 0;
    if (counterY < height-1) begin 
    counterY <= counterY + 1;
    end
    else if (counterY == height-1) begin
    done_ <= 1;
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
gameStart startScreen(
.address(address),
.clock(clk),
.q(color));

assign x_out = xOut + counterX;
assign y_out = yOut + counterY;
assign address = (y_out*8'd160) + x_out;
assign c_out = color;
endmodule
