module keyboard_tracker #(parameter PULSE_OR_HOLD = 0) (
input clock,
input reset,
inout PS2_CLK,
inout PS2_DAT,
output a, d,
output space
);

wire byte_received;
wire [7:0] newest_byte;

localparam
           MAKE            = 2'b00,
           BREAK           = 2'b01,
SECONDARY_MAKE  = 2'b10,
SECONDARY_BREAK = 2'b11,

A_CODE = 8'h1c,
D_CODE = 8'h23,
SPACE_CODE = 8'h29;

    reg [1:0] curr_state;
    reg a_press, d_press;
reg space_press;

reg a_lock, d_lock;
reg space_lock;

    assign a = a_press && ~(a_lock && PULSE_OR_HOLD);
    assign d = d_press && ~(d_lock && PULSE_OR_HOLD);


    assign space = space_press && ~(space_lock && PULSE_OR_HOLD);

PS2_Controller #(.INITIALIZE_MOUSE(0)) core_driver(
    .CLOCK_50(clock),
 .reset(~reset),
 .PS2_CLK(PS2_CLK),
 .PS2_DAT(PS2_DAT),
 .received_data(newest_byte),
 .received_data_en(byte_received)
 );
 
    always @(posedge clock) begin
 curr_state <= MAKE;
 a_lock <= a_press;
 d_lock <= d_press;
 space_lock <= space_press;
 
    if (~reset) begin
     curr_state <= MAKE;
a_press <= 1'b0;
d_press <= 1'b0;
space_press <= 1'b0;

a_lock <= 1'b0;
d_lock <= 1'b0;
space_lock <= 1'b0;
        end
 else if (byte_received) begin
case (newest_byte)
A_CODE: a_press <= curr_state == MAKE;
D_CODE: d_press <= curr_state == MAKE;
SPACE_CODE: space_press <= curr_state == MAKE;

8'he0: curr_state <= SECONDARY_MAKE;
8'hf0: curr_state <= curr_state == MAKE ? BREAK : SECONDARY_BREAK;
     endcase
        end
        else begin
     curr_state <= curr_state;
 end
    end
endmodule
