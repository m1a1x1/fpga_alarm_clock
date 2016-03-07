function string path_to_mif(
 
  int number

);
  string mif_path = "../rtl/numbers_mem/";
  string num;
  num = "0123456789";
  mif_path = {mif_path, num[number],".mif"};

  return mif_path;
endfunction

module num_to_pix #(
  
  parameter NUM_CNT = 10,
  parameter PIX_X_W = 12,
  parameter PIX_Y_W = 12,
  parameter MAX_X   = 80,

  parameter NUM_W = $clog2( NUM_CNT )

)(

  input               clk_i,
  input               rst_i,

  input [NUM_W-1:0]   num_i,

  input [PIX_X_W-1:0] pos_x_i,
  input [PIX_Y_W-1:0] pos_y_i,
 
  output              pix_o

);

logic [12:0] pix_addr;

logic [NUM_CNT-1:0] pix_all; 

assign pix_addr = ( pos_y_i * MAX_X ) + pos_x_i;

genvar i;
generate
  for( i = 0; i < NUM_CNT; i++ ) 
    begin: num_mem
   
      numbers_mem #(

        .MIF_FNAME ( path_to_mif( i ) )

      ) mem_inst (

        .address ( pix_addr   ),
        .clock   ( clk_i      ),
        .q       ( pix_all[i] )

      );
    end
endgenerate

assign pix_o = pix_all[ num_i ];

endmodule
