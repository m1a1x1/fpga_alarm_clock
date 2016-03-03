interface posix_time_ctrl_if;

  logic  [31:0] usr_posix_time;
  logic         usr_posix_time_en;
  logic         usr_unset_alarm;


modport in(

  input  usr_posix_time,
         usr_posix_time_en,
         usr_unset_alarm

);

modport out(

  output  usr_posix_time,
          usr_posix_time_en,
          usr_unset_alarm

); 

endinterface
