`include "../defines/vjtag_regs.vh"

module vjtag_to_if #(

  parameter IR_W       = 3,
  parameter DATA_W     = 32,
  parameter ALARMS_CNT = 7

)(
 
  input                   clk_i,
  input                   rst_i,
  
  vjtag_if.in             vjtag_if,
  posix_time_ctrl_if.out  user_time_if,
  posix_time_ctrl_if.out  alarm_set_time_if [ALARMS_CNT-1:0]

); 

localparam SINC_D = 3;

logic                           jclk;
logic [DATA_W-1:0]              data_shift_reg;
logic                           data;
logic                           data_val;
logic [IR_W-1:0]                cmd;       
logic [DATA_W-1:0]              tmp_data;

logic [SINC_D-1:0][DATA_W-1:0]  data_new_clk_d;
logic [SINC_D:0]                en_new_clk_d;

logic [IR_W-1:0]                last_cmd;

logic [DATA_W-1:0]              cmd_data;
logic [`CMD_CNT-1:0]            cmd_data_val;


assign jclk        = vjtag_if.tck;
assign data        = vjtag_if.tdi; 
assign data_val    = vjtag_if.virtual_state_sdr;
assign end_of_data = vjtag_if.virtual_state_udr;
assign cmd         = vjtag_if.ir_in;

assign valid_cmd = ( cmd == `SET_TIME_CMD      ) || 
                   ( cmd == `SET_ALARM_0_CMD   ) ||
                   ( cmd == `UNSET_ALARM_0_CMD ) ||
                   ( cmd == `SET_ALARM_1_CMD   ) ||
                   ( cmd == `UNSET_ALARM_1_CMD ) ||
                   ( cmd == `SET_ALARM_2_CMD   ) ||
                   ( cmd == `UNSET_ALARM_2_CMD ) ||
                   ( cmd == `SET_ALARM_3_CMD   ) ||
                   ( cmd == `UNSET_ALARM_3_CMD ) ||
                   ( cmd == `SET_ALARM_4_CMD   ) ||
                   ( cmd == `UNSET_ALARM_4_CMD ) ||
                   ( cmd == `SET_ALARM_5_CMD   ) ||
                   ( cmd == `UNSET_ALARM_5_CMD ) ||
                   ( cmd == `SET_ALARM_6_CMD   ) ||
                   ( cmd == `UNSET_ALARM_6_CMD );

always_ff @( posedge jclk or posedge rst_i )
  begin
   if( rst_i )
     data_shift_reg <= '0;
   else
     begin
       if( data_val && valid_cmd )
         data_shift_reg <= { data, data_shift_reg[DATA_W-1:1] };
     end
  end

always @( posedge jclk or posedge rst_i )
  begin
    if( rst_i )
      begin
        tmp_data <= '0;
        last_cmd <= '0;
      end
    else
      begin
        if( end_of_data )
          begin
            last_cmd <= cmd;
            tmp_data <= data_shift_reg;
          end
      end
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      data_new_clk_d <= '0;
    else
      begin
        data_new_clk_d[0]  <= tmp_data;
        for ( int i = 1; i < SINC_D; i++ )
          data_new_clk_d[i]  <= data_new_clk_d[i-1];
      end
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      en_new_clk_d <= '0;
    else
      begin
        en_new_clk_d[0] <= end_of_data;
        for ( int i = 1; i < SINC_D+1; i++ )
          en_new_clk_d[i] <= en_new_clk_d[i-1];
      end
  end

always_comb
  begin
    cmd_data_val = '0;
    for( int i = 0; i < `CMD_CNT; i++ )
      begin
        cmd_data_val[i] = ( last_cmd == i                                   ) && 
                          ( en_new_clk_d[SINC_D] && ~en_new_clk_d[SINC_D-1] );

      end
  end

assign cmd_data = data_new_clk_d[SINC_D-1];  

posix_time_regs_to_if posix_time_regs_to_if(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),

  .time_val_i        ( cmd_data_val[`SET_TIME_CMD]      ),

  .user_time_if      ( user_time_if                     )

);

alarm_clock_regs_to_if alarm_regs_inst0(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_0_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_0_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[0]             )

);

alarm_clock_regs_to_if alarm_regs_inst1(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_1_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_1_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[1]             )

);

alarm_clock_regs_to_if alarm_regs_inst2(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_2_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_2_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[2]             )

);

alarm_clock_regs_to_if alarm_regs_inst3(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_3_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_3_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[3]             )

);

alarm_clock_regs_to_if alarm_regs_inst4(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_4_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_4_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[4]             )

);

alarm_clock_regs_to_if alarm_regs_inst5(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_5_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_5_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[5]             )

);

alarm_clock_regs_to_if alarm_regs_inst6(

  .clk_i             ( clk_i                            ),
  .rst_i             ( rst_i                            ),

  .time_i            ( cmd_data                         ),
  .time_val_i        ( cmd_data_val[`SET_ALARM_6_CMD]   ),
  .unset_alarm_i     ( cmd_data_val[`UNSET_ALARM_6_CMD] ),

  .alarm_set_time_if ( alarm_set_time_if[6]             )

);

assign vjtag_if.tdo = ( valid_cmd ) ? ( data_shift_reg[0] ) : 
                                      ( vjtag_if.tdi      );

endmodule
