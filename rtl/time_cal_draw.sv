`include "../defines/time_cal_draw_def.vh"
`include "../defines/colors.vh"


module time_cal_draw #(
  parameter ALARMS_CNT = 7,
  parameter BG_COLOR   = 3'b000,
  parameter TIME_COLOR = 3'b111,
  parameter PIX_X_W    = 12,
  parameter PIX_Y_W    = 12

)(

  input              clk_50_i,
  input              clk_25_i,

  input              rst_i,

  time_if.in         time_info,
  date_if.in         date_info,

  date_if.in         alarms_info [ALARMS_CNT-1:0],
  pixels_if.in       pix_if,

  vga_if.out         vga_if 

);

localparam  H_LL_BORDER     =  `H_LL_BORDER;    
localparam  H_RL_BORDER     =  `H_RL_BORDER;       
localparam  HDOT_L_BORDER   =  `HDOT_L_BORDER;  
localparam  M_LL_BORDER     =  `M_LL_BORDER;    
localparam  M_RL_BORDER     =  `M_RL_BORDER;    
localparam  DOT_L_BORDER    =  `DOT_L_BORDER;   
localparam  S_LL_BORDER     =  `S_LL_BORDER;    
localparam  S_RL_BORDER     =  `S_RL_BORDER;    
localparam  H_TOP_BORDER    =  `H_TOP_BORDER;   
localparam  HDOT_TOP_BORDER =  `HDOT_TOP_BORDER;
localparam  M_TOP_BORDER    =  `M_TOP_BORDER;   
localparam  DOT_TOP_BORDER  =  `DOT_TOP_BORDER; 
localparam  S_TOP_BORDER    =  `S_TOP_BORDER;   

localparam  CAL_L_BORDER    = `CAL_L_BORDER;

localparam  CAL_TOP_BORDER  = `CAL_TOP_BORDER;

localparam VGA_D   = 1;
localparam NUM_CNT = 10;
localparam NUM_W   = $clog2( NUM_CNT );
localparam POS_W   = $clog2( `POS_CNT );

logic                           cur_number_draw;

logic  [`DOT_W-1:0][`DOT_H-1:0] dot;


logic  [`POS_CNT-1:0][NUM_W-1:0] all_nums_unsync;
logic  [`POS_CNT-1:0][NUM_W-1:0] all_nums_sync;

logic  [NUM_W-1:0]  hour_left_sync;  
logic  [NUM_W-1:0]  hour_right_sync; 

logic  [NUM_W-1:0]  min_left_sync;   
logic  [NUM_W-1:0]  min_right_sync;  

logic  [NUM_W-1:0]  sec_left_sync;   
logic  [NUM_W-1:0]  sec_right_sync;  

logic  [NUM_W-1:0]  cur_num;  

logic  [2:0]        cal_pix_color;


logic  [POS_W-1:0]       cur_pos;
                                
logic  [PIX_X_W-1:0]     pos_x;
logic  [PIX_Y_W-1:0]     pos_y;

logic  [2:0]             vga_color;
logic  [VGA_D:1]         vga_vs_d;
logic  [VGA_D:1]         vga_hs_d;
logic  [VGA_D:1]         vga_de_d;


always_ff @( posedge clk_25_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        vga_vs_d <= '0;
        vga_hs_d <= '0;
                
        vga_de_d <= '0;
      end
    else
      begin
        vga_vs_d[1] <= pix_if.vs;
        vga_hs_d[1] <= pix_if.hs;
                
        vga_de_d[1] <= pix_if.de;
        for( int i = 2; i < VGA_D+1; i++ )
          begin
            vga_vs_d[i] <= vga_vs_d[i-1];
            vga_hs_d[i] <= vga_hs_d[i-1];
                    
            vga_de_d[i] <= vga_de_d[i-1];
          end
      end
  end

always_comb
  begin
    for( int i = 0; i < `DOT_W; i++ )
      begin
        for( int j = 0; j < `DOT_H; j++ )
          dot[i][j] = time_info.blink; 
      end
  end

always_comb
  begin
   all_nums_unsync = '0;

   all_nums_unsync[`H_LEFT]  = time_info.hour / 10;
   all_nums_unsync[`H_RIGHT] = time_info.hour % 10;

   all_nums_unsync[`M_LEFT]  = time_info.min / 10;
   all_nums_unsync[`M_RIGHT] = time_info.min % 10;

   all_nums_unsync[`S_LEFT]  = time_info.sec / 10;
   all_nums_unsync[`S_RIGHT] = time_info.sec % 10;
  end

assign cur_pos = `CUR_POS(pix_if.x,pix_if.y);

assign pos_x = ( ( cur_pos == `H_LEFT  ) ? ( pix_if.x - H_LL_BORDER   ) : 
                 ( cur_pos == `H_RIGHT ) ? ( pix_if.x - H_RL_BORDER   ) : 
                 ( cur_pos == `HDOT    ) ? ( pix_if.x - HDOT_L_BORDER ) : 
                 ( cur_pos == `M_LEFT  ) ? ( pix_if.x - M_LL_BORDER   ) : 
                 ( cur_pos == `M_RIGHT ) ? ( pix_if.x - M_RL_BORDER   ) : 
                 ( cur_pos == `DOT     ) ? ( pix_if.x - DOT_L_BORDER  ) : 
                 ( cur_pos == `S_LEFT  ) ? ( pix_if.x - S_LL_BORDER   ) : 
                 ( cur_pos == `S_RIGHT ) ? ( pix_if.x - S_RL_BORDER   ) : 
                 ( cur_pos == `CAL     ) ? ( pix_if.x - CAL_L_BORDER   ) : 
                 ( 'd0                 )                              );

assign pos_y = ( ( cur_pos == `H_LEFT  ) ? ( pix_if.y - H_TOP_BORDER    ) : 
                 ( cur_pos == `H_RIGHT ) ? ( pix_if.y - H_TOP_BORDER    ) : 
                 ( cur_pos == `HDOT    ) ? ( pix_if.y - HDOT_TOP_BORDER ) : 
                 ( cur_pos == `M_LEFT  ) ? ( pix_if.y - M_TOP_BORDER    ) : 
                 ( cur_pos == `M_RIGHT ) ? ( pix_if.y - M_TOP_BORDER    ) : 
                 ( cur_pos == `DOT     ) ? ( pix_if.y - DOT_TOP_BORDER  ) : 
                 ( cur_pos == `S_LEFT  ) ? ( pix_if.y - S_TOP_BORDER    ) : 
                 ( cur_pos == `S_RIGHT ) ? ( pix_if.y - S_TOP_BORDER    ) : 
                 ( cur_pos == `CAL     ) ? ( pix_if.y - CAL_TOP_BORDER  ) : 
                 ( 'd0                 )                                 );

always_comb
  begin
    vga_color = BG_COLOR;
    case( cur_pos )

      `BG:
        begin
          vga_color = BG_COLOR;
        end

      `DOT:
        begin
          vga_color =( dot[pos_x][pos_y] ) ? ( TIME_COLOR ) :
                                             ( BG_COLOR   );
        end

      `HDOT:
        begin
          vga_color = TIME_COLOR;
        end

      `CAL:
        begin
          vga_color = cal_pix_color;
        end

      default:
        begin
          vga_color = cur_number_draw ? ( TIME_COLOR ) :
                                        ( BG_COLOR   );
        end

    endcase
  end

sync #(

  .ARRAY_W        ( `POS_CNT         ),
  .DATA_W         ( NUM_W           ),
  .SYNC_D         ( 3               )

) num_sync (

  .clk_sync_i     ( clk_25_i        ),
  .rst_i          ( rst_i           ),

  .unsync_data_i  ( all_nums_unsync ),           
  .sync_data_o    ( all_nums_sync   )           

);

assign cur_num = all_nums_sync[ cur_pos ];

num_to_pix #(

  .NUM_CNT   ( NUM_CNT         ),

  .PIX_X_W   ( PIX_X_W         ),
  .PIX_Y_W   ( PIX_Y_W         ),
  
  .MAX_X     ( `NUM_W          )

) num_to_pix_inst (

  .clk_i     ( clk_25_i        ),
  .rst_i     ( rst_i           ),

  .num_i     ( cur_num         ),
  
  .pos_x_i   ( pos_x           ),
  .pos_y_i   ( pos_y           ),
  
  .pix_o     ( cur_number_draw )

);

cal_draw #(

  .ALARMS_CNT    ( ALARMS_CNT   ),
  .FRAME_COLOR   ( `WIGHT       ),
  .BG_COLOR      ( BG_COLOR     ),
  .TEXT_COLOR    ( TIME_COLOR   ),
  .CUR_DAY_COLOR ( `BLUE        )

) cal_draw (
  
  .clk_50_i     ( clk_50_i        ),
  .clk_25_i     ( clk_25_i        ),

  .rst_i        ( rst_i           ),

  .time_info    ( time_info       ),
  .date_info    ( date_info       ),

  .alarms_info  ( alarms_info      ),

  .pos_x_i      ( pos_x           ),
  .pos_y_i      ( pos_y           ),

  .pix_color_o  ( cal_pix_color   )

);



assign vga_if.red   = ( vga_de_d[VGA_D] ) ? ( vga_color[2] ) : 1'b0;
assign vga_if.green = ( vga_de_d[VGA_D] ) ? ( vga_color[1] ) : 1'b0;
assign vga_if.blue  = ( vga_de_d[VGA_D] ) ? ( vga_color[0] ) : 1'b0; 

assign vga_if.hs = vga_hs_d[VGA_D];
assign vga_if.vs = vga_vs_d[VGA_D];

endmodule
