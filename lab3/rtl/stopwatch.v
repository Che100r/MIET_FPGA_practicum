module stopwatch(
    input        clk100_i,
    input        rstn_i,
    input        start_stop_i,
    input        set_i,
    input        change_i,
    output [6:0] hex0_o,
    output [6:0] hex1_o,
    output [6:0] hex2_o,
    output [6:0] hex3_o
);

reg [2:0]  start_stop_sync;
reg [13:0] pulse_counter;
reg        device_state;

localparam PULS_MAX         = 14'd999; 
localparam NUMBER_00_01_MAX = 4'd9;
localparam NUMBER_00_10_MAX = 4'd9;
localparam NUMBER_01_00_MAX = 4'd9;
localparam NUMBER_10_00_MAX = 4'd9;

wire start_stop_pressed;
wire pulse_counter_passed = ( pulse_counter == PULS_MAX );

assign start_stop_pressed = ~start_stop_sync[2] & start_stop_sync[1];

always @( posedge clk100_i ) 
  begin
    start_stop_sync[0] <= !start_stop_i;
    start_stop_sync[1] <= start_stop_sync[0];
    start_stop_sync[2] <= start_stop_sync[1];
  end

always @( posedge clk100_i )
  begin
    if ( start_stop_pressed )
      device_state = ~device_state;

    if ( device_state == 1 ) 
      pulse_counter <= pulse_counter + 1;
    
    if ( device_state == 0 | pulse_counter_passed )
      pulse_counter <= 0;
          
  end

always @( posedge rstn_i )
  begin
    if ( rstn_i == 0) begin
      pulse_counter <= 0;
      device_state <= 0;
    end
    
endmodule