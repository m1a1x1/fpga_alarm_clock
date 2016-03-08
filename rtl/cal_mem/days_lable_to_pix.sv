`include "../defines/cal_draw_def.vh"

module days_lable_to_pix #(
 
  parameter DAYS_CNT  = 7, 
  parameter PIX_X_W   = 12,
  parameter PIX_Y_W   = 12,
  parameter MAX_X     = 130,
  parameter MAX_Y     = 30,

  parameter DAYS_W   = $clog2( DAYS_CNT ),
  parameter POS_W    = $clog2( `CAL_POS_CNT )

)(

  input               clk_i,
  input               rst_i,

  input [POS_W-1:0]   cur_pos_i,

  input [PIX_X_W-1:0] pos_x_i,
  input [PIX_Y_W-1:0] pos_y_i,
 
  output              pix_o

);

localparam L_OFFSET = 1;

logic [`CAL_POS_CNT-1:0][12:0]        all_pix_addr;

logic                                 pix; 

logic [POS_W-1:0]                     cur_pos;

logic  [`CAL_POS_CNT-1:0][DAYS_W-1:0] all_offsets;

logic                                 in_offset;

logic                   [12:0]  pos_x;
logic                   [12:0]  pos_y;

assign pos_x = ( pos_x_i - L_OFFSET );

assign pos_y = pos_y_i;

assign in_offset = (pos_x_i < L_OFFSET) || ( pos_x_i >= L_OFFSET + MAX_X );

always_comb
  begin
    all_offsets = '0;

    all_offsets[`MON_LABLE] = 'd0;
    all_offsets[`TUE_LABLE] = 'd1;
    all_offsets[`WED_LABLE] = 'd2;
    all_offsets[`THU_LABLE] = 'd3;
    all_offsets[`FRI_LABLE] = 'd4;
    all_offsets[`SAT_LABLE] = 'd5;
    all_offsets[`SUN_LABLE] = 'd6;
  end                    

always_comb             
  begin
    all_pix_addr = '0;

    all_pix_addr[`MON_LABLE] = ( ( all_offsets[`MON_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
    all_pix_addr[`TUE_LABLE] = ( ( all_offsets[`TUE_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
    all_pix_addr[`WED_LABLE] = ( ( all_offsets[`WED_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
    all_pix_addr[`THU_LABLE] = ( ( all_offsets[`THU_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );
    all_pix_addr[`FRI_LABLE] = ( ( all_offsets[`FRI_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );                                                                                                                                                                                                                  
    all_pix_addr[`SAT_LABLE] = ( ( all_offsets[`SAT_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );                                                                                                                                                                                                                  
    all_pix_addr[`SUN_LABLE] = ( ( all_offsets[`SUN_LABLE] * MAX_Y * MAX_X ) + ( ( pos_y * MAX_X ) + pos_x ) );                                                                                                                                                                                                                    
  end

days_lable_mem #(

  .MIF_FNAME ( "../rtl/cal_mem/days_lable_mem/days_lable.mif"  )

) days_lable_inst (

  .address   ( all_pix_addr[cur_pos_i] ),
  .clock     ( clk_i                   ),
  .q         ( pix                     )

);

assign pix_o = ( in_offset ) ? (1'b0) : ( pix );

endmodule
