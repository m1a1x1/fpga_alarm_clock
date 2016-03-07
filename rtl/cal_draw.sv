`include "../defines/cal_draw_def.vh"

module cal_draw #(

  parameter ALARMS_CNT    = 7,
  parameter FRAME_COLOR   = 3'b111,
  parameter BG_COLOR      = 3'b000,
  parameter TEXT_COLOR    = 3'b111,
  parameter CUR_DAY_COLOR = 3'b101,
  parameter PIX_X_W       = 12,
  parameter PIX_Y_W       = 12

)(

  input                 clk_50_i,
  input                 clk_25_i,

  input                 rst_i,

  time_if.in            time_info,
  date_if.in            date_info,

  date_if.in            alarms_info [ALARMS_CNT-1:0],

  input [PIX_X_W-1:0]   pos_x_i,
  input [PIX_Y_W-1:0]   pos_y_i,

  output [2:0]          pix_color_o
);

localparam POS_W = $clog2( `POS_CNT );

localparam YEAR_L_BORDER           = `YEAR_L_BORDER;                            
localparam MONTH_L_BORDER          = `MONTH_L_BORDER;                           
localparam DAYS_NAMES_MON_L_BORDER = `DAYS_NAMES_MON_L_BORDER;                 
localparam DAYS_NAMES_TUE_L_BORDER = `DAYS_NAMES_TUE_L_BORDER;                 
localparam DAYS_NAMES_WED_L_BORDER = `DAYS_NAMES_WED_L_BORDER;                 
localparam DAYS_NAMES_THU_L_BORDER = `DAYS_NAMES_THU_L_BORDER;                 
localparam DAYS_NAMES_FRI_L_BORDER = `DAYS_NAMES_FRI_L_BORDER;                 
localparam DAYS_NAMES_SAT_L_BORDER = `DAYS_NAMES_SAT_L_BORDER;                 
localparam DAYS_NAMES_SUN_L_BORDER = `DAYS_NAMES_SUN_L_BORDER;                 
                                                              
localparam YEAR_TOP_BORDER         = `YEAR_TOP_BORDER;        
localparam MONTH_TOP_BORDER        = `MONTH_TOP_BORDER;       
localparam DAYS_NAMES_TOP_BORDER   = `DAYS_NAMES_TOP_BORDER;                   
                                         
                                         
logic  [POS_W-1:0]       cur_pos;
                                
logic  [PIX_X_W-1:0]     pos_x;
logic  [PIX_Y_W-1:0]     pos_y;

logic                    month_pix;

assign cur_pos = `CUR_POS(pos_x_i,pos_y_i);

assign pos_x = ( ( cur_pos == `YEAR      ) ? ( pos_x_i - YEAR_L_BORDER           ) : 
                 ( cur_pos == `MONTH     ) ? ( pos_x_i - MONTH_L_BORDER          ) : 
                 ( cur_pos == `MON_LABLE ) ? ( pos_x_i - DAYS_NAMES_MON_L_BORDER ) : 
                 ( cur_pos == `TUE_LABLE ) ? ( pos_x_i - DAYS_NAMES_TUE_L_BORDER ) : 
                 ( cur_pos == `WED_LABLE ) ? ( pos_x_i - DAYS_NAMES_WED_L_BORDER ) : 
                 ( cur_pos == `THU_LABLE ) ? ( pos_x_i - DAYS_NAMES_THU_L_BORDER ) : 
                 ( cur_pos == `FRI_LABLE ) ? ( pos_x_i - DAYS_NAMES_FRI_L_BORDER ) : 
                 ( cur_pos == `SAT_LABLE ) ? ( pos_x_i - DAYS_NAMES_SAT_L_BORDER ) : 
                 ( cur_pos == `SUN_LABLE ) ? ( pos_x_i - DAYS_NAMES_SUN_L_BORDER ) : 
                 ( cur_pos == `TABLE     ) ? ( pos_x_i                           ) : 
                 ( 'd0                   )                                       );

assign pos_y = ( ( cur_pos == `YEAR      ) ? ( pos_y_i - YEAR_TOP_BORDER         ) : 
                 ( cur_pos == `MONTH     ) ? ( pos_y_i - MONTH_TOP_BORDER        ) : 
                 ( cur_pos == `MON_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `TUE_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `WED_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `THU_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `FRI_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `SAT_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `SUN_LABLE ) ? ( pos_y_i - DAYS_NAMES_TOP_BORDER   ) : 
                 ( cur_pos == `TABLE     ) ? ( pos_y_i                           ) : 
                 ( 'd0                 )                                         );

always_comb
  begin
    pix_color_o = FRAME_COLOR;
    case( cur_pos )

      `FRAME:
        begin
          pix_color_o = FRAME_COLOR;
        end

      `MONTH:
        begin
          pix_color_o = ( month_pix ) ? ( TEXT_COLOR ) : ( BG_COLOR );
        end

      default:
        begin
          pix_color_o = TEXT_COLOR;
        end

    endcase
  end

month_to_pix #(

  .MONTH_CNT ( 12               ),
 
  .PIX_X_W   ( PIX_X_W          ),
  .PIX_Y_W   ( PIX_Y_W          ),
  
  .MAX_X     ( 130              ) // REAL WIDTH OF MONTH WORD (TO REDUCE MEM)

) month_to_pix (

  .clk_i     ( clk_25_i         ),
  .rst_i     ( rst_i            ),

  .month_i   ( date_info.month  ),
  
  .pos_x_i   ( pos_x            ),
  .pos_y_i   ( pos_y            ),
  
  .pix_o     ( month_pix        )

);

endmodule
