module alarm_clock_fsm(

  input        clk_i,
  input        rst_i,

  input        alarm_set_i,
  input        alarm_unset_i,
  input        alarm_off_i,
  input        alarm_start_i,
  input        alarm_timeout_i,
  input        alarm_force_snooze_i,
  input        alarm_snooze_timeout_i,

  output       in_alarm_set_o,
  output       in_snooze_o,
  output       in_alarm_o

);

enum logic [2:0] { IDLE_S      = 3'b000,
                   ALARM_SET_S = 3'b001,
                   IN_ALARM_S  = 3'b010,
                   IN_SNOOZE_S = 3'b011 } state, next_state;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      state <= IDLE_S;
    else
      state <= next_state;
  end

always_comb
  begin
    next_state = IDLE_S;
    case ( state )
      IDLE_S:
        begin
          if( alarm_set_i )
            next_state = ALARM_SET_S;
          else
            next_state = state;
        end 
      ALARM_SET_S:
        begin
          if( alarm_unset_i )
            next_state = IDLE_S;
          else
            begin
              if( alarm_start_i )
                next_state = IN_ALARM_S;
              else
                next_state = state;
            end
        end
      IN_ALARM_S:
        begin
          if( alarm_off_i )
            next_state = IDLE_S;
          else
            begin
              if( alarm_timeout_i )
                next_state = IN_SNOOZE_S;
              else
                begin
                  if( alarm_force_snooze_i )
                    next_state = IN_SNOOZE_S;
                  else
                    next_state = state;
                end
            end
        end 
      IN_SNOOZE_S:
        begin
          if( alarm_off_i )
            next_state = IDLE_S;
          else
            begin
              if( alarm_snooze_timeout_i )
                next_state = IN_ALARM_S;
              else
                next_state = state;
            end
        end
      default:
        begin
          next_state = IDLE_S;
        end
    endcase
 end

assign in_alarm_o     = ( state == IN_ALARM_S  );
assign in_snooze_o    = ( state == IN_SNOOZE_S );
assign in_alarm_set_o = ( state != IDLE_S      );

endmodule
