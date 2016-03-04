module sync #(

  parameter ARRAY_W = 9,
  parameter DATA_W  = 12,
  parameter SYNC_D  = 3

) (

  input                                   clk_sync_i,
  input                                   rst_i,
  input [ARRAY_W-1:0][DATA_W-1:0]         unsync_data_i,
  output logic [ARRAY_W-1:0][DATA_W-1:0]  sync_data_o           

);

logic [SYNC_D:1][ARRAY_W-1:0][DATA_W-1:0] unsync_d;

always_ff @( posedge clk_sync_i or posedge rst_i )
  begin
    if( rst_i )
      unsync_d <= '0;     
    else
      begin
        unsync_d[1] <= unsync_data_i;

        for( int i = 2; i < SYNC_D+1; i++ )
          unsync_d[i] <= unsync_d[i-1];
      end
  end

assign sync_data_o = unsync_d[SYNC_D];

endmodule
