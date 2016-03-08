`include "../defines/year_draw_def.vh"

module year_to_pix #(
 
  parameter NUM_CNT   = 10, 
  parameter PIX_X_W   = 12,
  parameter PIX_Y_W   = 12,
  parameter MAX_X     = 130,
  parameter MAX_Y     = 30,

  parameter NUM_W   = $clog2( NUM_CNT ),
  parameter YEAR_W  = $clog2( 3000 )

)(

  input               clk_i,
  input               rst_i,

  input [YEAR_W-1:0]  year_i,

  input [PIX_X_W-1:0] pos_x_i,
  input [PIX_Y_W-1:0] pos_y_i,
 
  output              pix_o

);

localparam POS_W = $clog2(`NUM_POS_CNT);

localparam THOUSANDS_L_BORDER = `THOUSANDS_L_BORDER;                                            
localparam HUNDREDS_L_BORDER  = `HUNDREDS_L_BORDER;                                             
localparam DOZENS_L_BORDER    = `DOZENS_L_BORDER;                                     
localparam UNITS_L_BORDER     = `UNITS_L_BORDER;                                                 



logic [`NUM_POS_CNT-1:0][12:0]  all_pix_addr;

logic                   [12:0]  pos_x;
logic                   [12:0]  pos_y;

logic                           pix; 

logic [POS_W-1:0]               cur_pos;

logic  [`NUM_POS_CNT-1:0][NUM_W-1:0] all_nums;


always_comb
  begin
    all_nums = '0;

    all_nums[`THOUSANDS]  = ( year_i / 1000 ) % 10;
    all_nums[`HUNDREDS]   = ( year_i / 100 ) % 10;
    all_nums[`DOZENS]     = ( year_i / 10 ) % 10;
    all_nums[`UNITS]      = ( year_i % 10 );
  end

assign cur_pos = `CUR_NUM_POS(pos_x_i,pos_y_i);

assign pos_x = ( ( cur_pos == `THOUSANDS ) ? ( pos_x_i - THOUSANDS_L_BORDER ) : 
                 ( cur_pos == `HUNDREDS  ) ? ( pos_x_i - HUNDREDS_L_BORDER  ) : 
                 ( cur_pos == `DOZENS    ) ? ( pos_x_i - DOZENS_L_BORDER    ) : 
                 ( cur_pos == `UNITS     ) ? ( pos_x_i - UNITS_L_BORDER     ) : 
                 ( 'd0                   )                                  );

assign pos_y = pos_y_i;

always_comb
  begin
   all_pix_addr = '0;

   all_pix_addr[`THOUSANDS] = ( ( all_nums[`THOUSANDS] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
   all_pix_addr[`HUNDREDS]  = ( ( all_nums[`HUNDREDS] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
   all_pix_addr[`DOZENS]    = ( ( all_nums[`DOZENS] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
   all_pix_addr[`UNITS]     = ( ( all_nums[`UNITS] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
  end

year_nums_mem #(

  .MIF_FNAME ( "../rtl/cal_mem/year_mem/numbers.mif"  )

) year_nums_inst (

  .address   ( all_pix_addr[cur_pos] ),
  .clock     ( clk_i                 ),
  .q         ( pix                   )

);

assign pix_o = ( cur_pos == `Y_BG ) ? ( 1'b0 ) : ( pix );

endmodule
