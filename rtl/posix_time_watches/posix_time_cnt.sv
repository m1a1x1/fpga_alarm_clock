module posix_time_cnt #(

  parameter START_POSIX_TIME = 32'd0,
  parameter CLK_FREQ         = 50

) (

  input               clk_i,
  input               rst_i,
 
  input  [31:0]       user_posix_time_i,
  input               user_posix_time_en_i,

  output logic [31:0] posix_time_o,

  output              last_tact_o

);

logic [$clog2( CLK_FREQ*(10**6) )-1:0] tacts_cnt;
logic                                  last_tact_w;
logic [31:0]                           posix_time_cnt;

assign last_tact_w  = ( tacts_cnt == ( CLK_FREQ*(10**6) - 1 ) );
 
always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        tacts_cnt      <= 0;
        posix_time_cnt <= START_POSIX_TIME;
      end
    else
      begin
        if( user_posix_time_en_i )
          begin
            tacts_cnt      <= 0;
            posix_time_cnt <= user_posix_time_i;
          end
        else
          begin
            if( last_tact_w )
              begin
                posix_time_cnt <= posix_time_cnt + 1;
                tacts_cnt      <= 0;
              end
            else
              begin
                tacts_cnt <= tacts_cnt + 1; 
              end
          end
      end 
  end

assign posix_time_o = posix_time_cnt;
assign last_tact_o  = last_tact_w; 

endmodule
