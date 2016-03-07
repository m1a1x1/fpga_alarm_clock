`include "../defines/colors.vh"

module main_alarm_clock#(
 
  // Correction of time ( posix time dont care about GMT ).
  parameter GMT        = 3, 

  parameter ALARMS_CNT = 7

)(
 
  input                                   clk_50_i,
  input                                   clk_25_i,

  input                                   rst_i,
  
  pixels_if.in                            pixels_if,

  posix_time_ctrl_if.in                   user_time_if,

  posix_time_ctrl_if.in                   alarm_set_time_if [ALARMS_CNT-1:0],

  alarm_ctrl_if.in                        alarm_ctrl_if,

  vga_if.out                              vga_out_if,

  output                 [ALARMS_CNT-1:0] alarm_o

); 

logic [31:0]   cur_posix_time;
logic          last_tick;

time_if        time_info( );

vga_if         time_vga_if( );
vga_if         default_vga_if( );

alarm_ctrl_if  tmp_alarm_ctrl_if[ALARMS_CNT-1:0] ();

posix_time_ctrl_if  alarm_time_if[ALARMS_CNT-1:0] ();

posix_time_watches #(

  .GMT                  ( GMT                            ),
  .START_POSIX_TIME     ( 123456                         )

) time_inst (

  .clk_i                ( clk_50_i                       ),
  .rst_i                ( rst_i                          ),

  .user_posix_time_i    ( user_time_if.usr_posix_time    ),
  .user_posix_time_en_i ( user_time_if.usr_posix_time_en ),

  .sec_blnk_o           ( time_info.blink                ),
  .min_o                ( time_info.min                  ),
  .hour_o               ( time_info.hour                 ),
  .sec_o                ( time_info.sec                  ),

  .posix_time_o         ( cur_posix_time                 ),
  .last_tick_o          ( last_tick                      )

);

date_if date_info();

date_if alarm_date_info[ALARMS_CNT-1:0] ();

posix_time_to_date date_inst(

  .clk_i                 ( clk_50_i                       ),
  .rst_i                 ( rst_i                          ),

  .posix_time_i          ( cur_posix_time                 ),

  .date_if               ( date_info                      )

);

genvar i;
generate
  for( i = 0; i < ALARMS_CNT; i++ ) 
    begin: alarm_inst
      assign tmp_alarm_ctrl_if[i].alarm_off_stb    = alarm_ctrl_if.alarm_off_stb;
      assign tmp_alarm_ctrl_if[i].alarm_snooze_stb = alarm_ctrl_if.alarm_snooze_stb;
      alarm_clock #(

        .GMT                  ( GMT                            ), 
        .ALARM_TIME_SEC       ( 10                             ),
        .SNOOZE_TIME_SEC      ( 5                              )

      ) alarm_clock (

        .clk_i                ( clk_50_i                       ),
        .rst_i                ( rst_i                          ),
                                                   
        .cur_posix_time_i     ( cur_posix_time                 ),
        .last_tick_i          ( last_tick                      ),
                                                   
        .alarm_set_time_if    ( alarm_set_time_if[i]           ),
        .alarm_ctrl_if        ( tmp_alarm_ctrl_if[i]           ),
                             
        .alarm_time_if        ( alarm_time_if[i]               ),                  
        .alarm_o              ( alarm_o[i]                     )          

      );

      posix_time_to_date alarm_date_inst(
        .clk_i                 ( clk_50_i                        ),
        .rst_i                 ( rst_i                           ),

        .posix_time_i          ( alarm_time_if[i].usr_posix_time ),

        .date_if               ( alarm_date_info[i]              )

      );
    end
endgenerate

time_cal_draw #(

  .ALARMS_CNT   ( ALARMS_CNT     ),
  .BG_COLOR     ( `BLACK         ),
  .TIME_COLOR   ( `GREEN         )

) time_draw (
  
  .clk_50_i     ( clk_50_i        ),
  .clk_25_i     ( clk_25_i        ),

  .rst_i        ( rst_i           ),

  .time_info    ( time_info       ),
  .date_info    ( date_info       ),

  .alarms_info  ( alarm_date_info ),
  .pix_if       ( pixels_if       ),

  .vga_if       ( time_vga_if     )

);

defaul_draw def_draw (

  .pix_if ( pixels_if      ),
  .vga_if ( default_vga_if )

);

logic [1:0] show_mode;

assign show_mode = 'd1;

vga_mux #(

  .DIR_CNT       ( 2               )

) vga_mux (

  .mod_i         ( show_mode       ),

  .vga_0_if      ( default_vga_if  ),
  .vga_1_if      ( time_vga_if     ),

  .vga_out_if    ( vga_out_if      ) 

);

endmodule
