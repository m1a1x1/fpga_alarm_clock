function string month_path_to_mif(
 
  int month_number

);
  string mif_path = "../rtl/cal_mem/month_mem/";
  string num;
  case( month_number )
    0 : num = "0001";
    1 : num = "0203";
    2 : num = "0405";
    3 : num = "0607";
    4 : num = "0809";
    5 : num = "1111";
  endcase
  mif_path = {mif_path, num,".mif"};

  return mif_path;
endfunction

module month_to_pix #(
  
  parameter MONTH_CNT = 12,
  parameter PIX_X_W   = 12,
  parameter PIX_Y_W   = 12,
  parameter MAX_X     = 130,
  parameter MAX_Y     = 30,

  parameter MONTH_W   = $clog2( MONTH_CNT )

)(

  input               clk_i,
  input               rst_i,

  input [MONTH_W-1:0] month_i,

  input [PIX_X_W-1:0] pos_x_i,
  input [PIX_Y_W-1:0] pos_y_i,
 
  output              pix_o

);

localparam OFFSET = 84;
localparam SECOND_MONTH_OFFSET = MAX_Y * MAX_X;

logic                  in_offset;
logic [1:0][12:0]      pix_addr;

logic [MONTH_CNT-1:0]  pix_all; 

assign in_offset = ( pos_x_i < OFFSET ) || ( pos_x_i >= ( OFFSET + MAX_X ) );

assign pix_addr[0] = ( pos_y_i * MAX_X ) + ( pos_x_i - OFFSET );
assign pix_addr[1] = ( ( ( pos_y_i * MAX_X ) + ( pos_x_i - OFFSET ) ) + SECOND_MONTH_OFFSET );

genvar i;
generate
  for( i = 0; i < MONTH_CNT / 2; i++ ) 
    begin: num_mem
   
      two_month_mem #(

        .MIF_FNAME ( month_path_to_mif( i ) )

      ) month_mem_inst (

        .address_a ( pix_addr[0]    ),
        .address_b ( pix_addr[1]    ),
        .clock     ( clk_i          ),
        .q_a       ( pix_all[i*2]   ),
        .q_b       ( pix_all[i*2+1] )

      );
    end
endgenerate

assign pix_o = ( in_offset ) ? ( 1'b0 ) : ( pix_all[ month_i ] );

endmodule
