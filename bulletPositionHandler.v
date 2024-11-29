module bulletPositionHandler(
    clk,
    inResetb,
    inUpdateb,
    inWaitb,
    pXIn,
    bulletX,
    bulletY,
    reachtop,
    active
);

    input clk, inResetb, inUpdateb, inWaitb;
    input [7:0] pXIn;
    output [7:0] bulletX;
    output [6:0] bulletY;
    output reg reachtop;
    output reg active;

    reg [7:0] xOut;
    reg [6:0] yOut;

    always @(posedge clk) begin
        if (inResetb) begin
            xOut <= pXIn;
            yOut <= 7'd99;
            reachtop <= 1'b0;
            active <= 1'b0;
        end
        else if (inUpdateb) begin
            active <= 1'b1;
            if (yOut > 7'd8) begin
                yOut <= yOut - 6;
                reachtop <= 1'b0;
            end
            else begin
                yOut <= 7'd99;
                xOut <= pXIn;
                reachtop <= 1'b1;
            end
        end
        else if (inWaitb) begin
            active <= 1'b1;
        end
    end

    assign bulletX = xOut;
    assign bulletY = yOut;
endmodule
