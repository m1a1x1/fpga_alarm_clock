module table_num_to_pix #(

  parameter NUM_CNT   = 31, 
  parameter PIX_X_W   = 12,
  parameter PIX_Y_W   = 12,
  parameter MAX_X     = 130,
  parameter MAX_Y     = 30,

  parameter NUM_W   = $clog2( NUM_CNT )

)(

  input               clk_i,
  input               rst_i,

  input [NUM_W-1:0]   cur_number_i,

  input [PIX_X_W-1:0] pos_x_i,
  input [PIX_Y_W-1:0] pos_y_i,
 
  output              pix_o

);

localparam L_OFFSET = 5;

logic                   [14:0]  pix_addr;

logic                           pix;

logic                           in_offset;

assign in_offset = (pos_x_i < L_OFFSET) || ( pos_x_i >= ( L_OFFSET + MAX_X ) );

assign pix_addr  = ( ( cur_number_i * MAX_Y * MAX_X ) + ( ( pos_y_i * MAX_X ) + pos_x_i - L_OFFSET ) );

table_nums_mem #(

  .MIF_FNAME ( "../rtl/cal_mem/table_mem/numbers.mif"  )

) table_nums_inst (

  .address   ( pix_addr ),
  .clock     ( clk_i    ),
  .q         ( pix      )

);

assign pix_o = ( in_offset ) ? ( 1'b0 ) : ( pix );

endmodule
