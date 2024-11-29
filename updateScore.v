module updateScore(clk, resetn, updateScore, HEX1, HEX2, inUpdatePositionStateMain, score);
input clk, resetn, updateScore, inUpdatePositionStateMain;
output [6:0] HEX1, HEX2;
output reg [7:0] score;
always @(posedge clk)
begin
if (!resetn)
score <= 0;
else begin
if (updateScore && inUpdatePositionStateMain)
if(score < 8'd255)
score <= score + 1;
else
score <= 8'd255;
else
score <= score;
end

end

seg7Display scoreDisplay1(HEX1, score[3:0]);
seg7Display scoreDisplay2(HEX2, score[7:4]);
endmodule
