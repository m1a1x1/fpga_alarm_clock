interface alarm_ctrl_if;

  logic     alarm_off_stb;
  logic     alarm_snooze_stb;

modport in(

  input  alarm_off_stb,
         alarm_snooze_stb
         

);

modport out(

  output  alarm_off_stb,
          alarm_snooze_stb
          
); 

endinterface
