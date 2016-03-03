module posix_time_regs_to_if(
 
  input                     clk_i,
  input                     rst_i,
  
  input  [31:0]             time_i,
  input                     time_val_i,

  posix_time_ctrl_if.out    user_time_if

); 

assign user_time_if.usr_posix_time    = time_i;
assign user_time_if.usr_posix_time_en = time_val_i;

endmodule
