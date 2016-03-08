`include "../defines/cal_draw_def.vh"

module table_draw #(

  parameter BG_COLOR      = 3'b000,
  parameter TEXT_COLOR    = 3'b111,
  parameter CUR_DAY_COLOR = 3'b101,
  parameter PIX_X_W       = 12,
  parameter PIX_Y_W       = 12

)(

  input                   clk_i,

  input                   rst_i,

  input [$clog2(7)-1:0]   month_first_day_i,   
  input [$clog2(31)-1:0]  month_days_cnt_i,    
                        
  input [$clog2(31)-1:0]  day_in_month_i,

  input [PIX_X_W-1:0]     pos_x_i,
  input [PIX_Y_W-1:0]     pos_y_i,

  output [2:0]            color_o
);

localparam POS_W = $clog2( `CELLS_CNT );

localparam ROW_CNT = `ROW_CNT;
localparam TABLE_CNT = `TABLE_CNT;

localparam ROW_W = $clog2( ROW_CNT );
localparam TABLE_W = $clog2( TABLE_CNT );

localparam DATE_W = $clog2( 31 );

localparam DO_NOT_SHOW = 'd0;
localparam CUR_DAY = 'd1;
localparam NORAL_DAY = 'd2;

localparam STAUS_CNT = 'd3;
localparam STATUS_W = $clog2( STAUS_CNT );

localparam T0_L_BORDER = `T0_L_BORDER;                                                                                                  
localparam T1_L_BORDER = `T1_L_BORDER;                                                                                                
localparam T2_L_BORDER = `T2_L_BORDER;                                                                                                
localparam T3_L_BORDER = `T3_L_BORDER;                                                                                                
localparam T4_L_BORDER = `T4_L_BORDER;                                                                                                
localparam T5_L_BORDER = `T5_L_BORDER;                                                                                                
localparam T6_L_BORDER = `T6_L_BORDER;                                                                                                

localparam R0_TOP_BORDER = `R0_TOP_BORDER;                                                                                                  
localparam R1_TOP_BORDER = `R1_TOP_BORDER;                                                                                                
localparam R2_TOP_BORDER = `R2_TOP_BORDER;                                                                                                
localparam R3_TOP_BORDER = `R3_TOP_BORDER;                                                                                                
localparam R4_TOP_BORDER = `R4_TOP_BORDER;                                                                                                
localparam R5_TOP_BORDER = `R5_TOP_BORDER;                                                                                                

logic  [PIX_X_W-1:0]     pos_x;
logic  [PIX_Y_W-1:0]     pos_y;

logic  [ROW_W-1:0]       cur_row;
logic  [TABLE_W-1:0]     cur_table;

logic  [ROW_CNT-1:0][TABLE_CNT-1:0][DATE_W-1:0] callendar;
logic  [ROW_CNT-1:0][TABLE_CNT-1:0][STATUS_W-1:0] callendar_status;

logic [DATE_W-1:0]       cur_number;

logic                    num_pix;

assign cur_row   = `CUR_ROW(pos_x_i,pos_y_i);
assign cur_table = `CUR_TABLE(pos_x_i,pos_y_i);

assign pos_x = ( ( cur_table == `T0 ) ? ( pos_x_i - T0_L_BORDER ) : 
                 ( cur_table == `T1 ) ? ( pos_x_i - T1_L_BORDER ) : 
                 ( cur_table == `T2 ) ? ( pos_x_i - T2_L_BORDER ) : 
                 ( cur_table == `T3 ) ? ( pos_x_i - T3_L_BORDER ) : 
                 ( cur_table == `T4 ) ? ( pos_x_i - T4_L_BORDER ) : 
                 ( cur_table == `T5 ) ? ( pos_x_i - T5_L_BORDER ) : 
                 ( cur_table == `T6 ) ? ( pos_x_i - T6_L_BORDER ) : 
                 ( 'd0              )                           );


assign pos_y = ( ( cur_row == `R0 ) ? ( pos_y_i - R0_TOP_BORDER ) : 
                 ( cur_row == `R1 ) ? ( pos_y_i - R1_TOP_BORDER ) : 
                 ( cur_row == `R2 ) ? ( pos_y_i - R2_TOP_BORDER ) : 
                 ( cur_row == `R3 ) ? ( pos_y_i - R3_TOP_BORDER ) : 
                 ( cur_row == `R4 ) ? ( pos_y_i - R4_TOP_BORDER ) : 
                 ( cur_row == `R5 ) ? ( pos_y_i - R5_TOP_BORDER ) : 
                 ( 'd0            )                             );

logic [DATE_W:0] number;

always_comb
  begin
    callendar        = '0;
    callendar_status = '0;
    number           = '0;
    for(int r = 0; r < ROW_CNT; r++ )
      begin
        for(int t = 0; t < TABLE_CNT; t++ )
          begin
            number = ( ( TABLE_CNT * r ) + t - month_first_day_i );
            callendar[r][t] = number;
            if( ( r == 0 ) && ( t < month_first_day_i ) )
              callendar_status[r][t] = DO_NOT_SHOW;
            else
              begin
                if( number >= month_days_cnt_i )
                  callendar_status[r][t] = DO_NOT_SHOW;
                else
                  begin
                    if( number == day_in_month_i )
                      callendar_status[r][t] = CUR_DAY;
                    else
                      callendar_status[r][t] = NORAL_DAY;
                   end
              end
          end
      end
  end

assign cur_number = callendar[cur_row][cur_table];

always_comb
  begin
    color_o = BG_COLOR;
    case( callendar_status[cur_row][cur_table] )

      DO_NOT_SHOW:
        begin
          //color_o = 3'b001;
          color_o = BG_COLOR;
        end

      NORAL_DAY:
        begin
          //color_o = TEXT_COLOR;
          color_o = ( num_pix ) ? ( TEXT_COLOR ) : ( BG_COLOR );
        end

      CUR_DAY:
        begin
          //color_o = CUR_DAY_COLOR;
          color_o = ( num_pix ) ? ( TEXT_COLOR ) : ( CUR_DAY_COLOR );
        end

     default:
        begin
          color_o = BG_COLOR;
        end

    endcase
  end


table_num_to_pix #(

  .NUM_CNT       ( 31               ),
  .PIX_X_W       ( PIX_X_W          ),
  .PIX_Y_W       ( PIX_Y_W          ),
  
  .MAX_X         ( 30               ),
  .MAX_Y         ( 30               ) 

) table_to_pix (

  .clk_i         ( clk_i            ),
  .rst_i         ( rst_i            ),

  .cur_number_i  ( cur_number       ),
  
  .pos_x_i       ( pos_x            ),
  .pos_y_i       ( pos_y            ),
  
  .pix_o         ( num_pix          )

);

endmodule
