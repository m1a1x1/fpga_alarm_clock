module posix_time_watches #(

  parameter GMT              = 3,
  parameter START_POSIX_TIME = 32'd0

)(

  input                         clk_i,
  input                         rst_i,

  input  [31:0]                 user_posix_time_i,
  input                         user_posix_time_en_i,

  output logic                  sec_blnk_o,
  output logic [$clog2(59)-1:0] min_o,
  output logic [$clog2(23)-1:0] hour_o,
  output logic [$clog2(59)-1:0] sec_o,

  output logic [31:0]           posix_time_o,
  
  output                        last_tick_o

);

logic [31:0]           posix_time;
logic                  last_tact;

posix_time_cnt #(

  .GMT                   ( GMT                   ),
  .START_POSIX_TIME      ( START_POSIX_TIME      )

) ptc (

  .clk_i                 ( clk_i                 ),
  .rst_i                 ( rst_i                 ),

  .user_posix_time_i     ( user_posix_time_i     ),
  .user_posix_time_en_i  ( user_posix_time_en_i  ),

  .posix_time_o          ( posix_time            ),
  .last_tact_o           ( last_tact             )

);

posix_time_to_time pt_t_t (

  .clk_i                  ( clk_i                ),
  .rst_i                  ( rst_i                ),

  .posix_time_i           ( posix_time           ),

  .hour_o                 ( hour_o               ),
  .min_o                  ( min_o                ),
  .sec_o                  ( sec_o                )

);

always_ff @( posedge clk_i, posedge rst_i )
  begin
    if( rst_i )
      begin
        sec_blnk_o <= 0;
      end
    else
      begin
        if( last_tact )
          sec_blnk_o <= ~sec_blnk_o;
      end
  end

assign posix_time_o = posix_time;
assign last_tick_o = last_tact;

endmodule
