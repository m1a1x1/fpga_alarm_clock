module alarm_clock_regs_to_if(
 
  input                     clk_i,
  input                     rst_i,
  
  input  [31:0]             time_i,
  input                     time_val_i,
  input                     unset_alarm_i,

  posix_time_ctrl_if.out    alarm_set_time_if

); 

assign alarm_set_time_if.usr_posix_time    = time_i;
assign alarm_set_time_if.usr_posix_time_en = time_val_i;
assign alarm_set_time_if.usr_unset_alarm   = unset_alarm_i;


endmodule
