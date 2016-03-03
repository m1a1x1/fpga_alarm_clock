module alarm_clock #(

  parameter ALARM_TIME_SEC  = 10,
  parameter SNOOZE_TIME_SEC = 5
 
)(

  input                     clk_i,

  input                     rst_i,
  
  input [31:0]              cur_posix_time_i,
  
  input                     last_tick_i,

  posix_time_ctrl_if.in     alarm_set_time_if,

  alarm_ctrl_if.in          alarm_ctrl_if,

  output                    alarm_o

);

logic [31:0]                       start_alarm_time;
logic [$clog2(ALARM_TIME_SEC):0]   in_alarm_sec_cnt;
logic [$clog2(SNOOZE_TIME_SEC):0]  in_snooze_sec_cnt;

logic                              alarm_set;
logic                              alarm_off;
logic                              alarm_start;
logic                              alarm_timeout;
logic                              alarm_force_snooze;
logic                              alarm_snooze_timeout;
logic                              alarm_unset;

enum logic [2:0] { IDLE_S      = 3'b000,
                   ALARM_SET_S = 3'b001,
                   IN_ALARM_S  = 3'b010,
                   IN_SNOOZE_S = 3'b011 } state;


always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      start_alarm_time <= 'd0;
    else
      begin
        if( alarm_set_time_if.usr_posix_time_en )
          begin
            start_alarm_time <= alarm_set_time_if.usr_posix_time;
         end
      end
  end

assign alarm_set            = alarm_set_time_if.usr_posix_time_en;
assign alarm_unset          = alarm_set_time_if.usr_unset_alarm;
assign alarm_start          = (cur_posix_time_i >= start_alarm_time);
assign alarm_off            = alarm_ctrl_if.alarm_off_stb;
assign alarm_force_snooze   = alarm_ctrl_if.alarm_snooze_stb;
assign alarm_timeout        = (in_alarm_sec_cnt  >= ALARM_TIME_SEC  );
assign alarm_snooze_timeout = (in_snooze_sec_cnt >= SNOOZE_TIME_SEC );

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      in_alarm_sec_cnt <= 'd0;
    else
      begin
        if( state == IN_ALARM_S )
          begin
            if( last_tick_i )
              in_alarm_sec_cnt <= in_alarm_sec_cnt + 1;
          end
        else
          in_alarm_sec_cnt <= 'd0;
      end
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      in_snooze_sec_cnt <= 'd0;
    else
      begin
        if( state == IN_SNOOZE_S )
          begin
            if( last_tick_i )
              in_snooze_sec_cnt <= in_snooze_sec_cnt + 1;
          end
        else
          in_snooze_sec_cnt <= 'd0;
      end
  end

alarm_clock_fsm alarm_clock_fsm(

  .clk_i                  ( clk_i                ),
  .rst_i                  ( rst_i                ),

  .alarm_set_i            ( alarm_set            ),
  .alarm_unset_i          ( alarm_unset          ),
  .alarm_off_i            ( alarm_off            ),
  .alarm_start_i          ( alarm_start          ),
  .alarm_timeout_i        ( alarm_timeout        ),
  .alarm_force_snooze_i   ( alarm_force_snooze   ),
  .alarm_snooze_timeout_i ( alarm_snooze_timeout ),

  .state_o                ( state                )

);

assign alarm_o = ( state == IN_ALARM_S );

endmodule
