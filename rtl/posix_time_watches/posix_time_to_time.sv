module posix_time_to_time (

  input                         clk_i,
  input                         rst_i,

  input  [31:0]                 posix_time_i,

  output logic [$clog2(23)-1:0] hour_o,
  output logic [$clog2(59)-1:0] min_o,
  output logic [$clog2(59)-1:0] sec_o

);

localparam SEC_IN_MIN  = 60;
localparam MIN_IN_HOUR = 60;
localparam HOUR_IN_DAY = 24;
localparam SEC_IN_HOUR = ( SEC_IN_MIN * MIN_IN_HOUR );

logic [$clog2(59)-1:0] min;
logic [$clog2(23)-1:0] hour;
logic [$clog2(59)-1:0] sec;

logic [31:0] cur_posix_time;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      cur_posix_time <= 'd0;
    else
      cur_posix_time <= posix_time_i[31:0];
  end

assign sec_o  = (   cur_posix_time                  % SEC_IN_MIN  );
assign min_o  = ( ( cur_posix_time / SEC_IN_MIN  )  % MIN_IN_HOUR );

always_comb
  begin
    hour_o = ( ( ( cur_posix_time / SEC_IN_HOUR ) ) % HOUR_IN_DAY );
  end

endmodule
