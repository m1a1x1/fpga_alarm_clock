`include "../defines/date_def.vh"

function bit leap_year(

  input [$clog2(3000)-1:0] year

);

bit year_is_leap;

if( ( year % 4 ) == 0 )
  begin
    if( ( year % 100 ) == 0 )
      begin
        if( ( year % 400 ) == 0 )
          year_is_leap = 1'b1;
        else
          year_is_leap = 1'b0;
      end
    else
      year_is_leap = 1'b1;
  end
else
  year_is_leap = 1'b0;

return year_is_leap;

endfunction

module posix_time_to_date(

  input         clk_i,
  input         rst_i,
  
  input [31:0]  posix_time_i,

  date_if.out   date_if

);

localparam FIRST_YEAR = 1970;
localparam MAX_YEAR = 3000;

localparam WEEK_DAYS_CNT = 7;
localparam WEEK_DAYS_W = $clog2(WEEK_DAYS_CNT);
localparam YEAR_W = $clog2(MAX_YEAR);

localparam MAX_MONTH_DAYS = 31;
localparam DAY_NUMBER_W = $clog2(MAX_MONTH_DAYS);

localparam MONTH_W = $clog2(`MONTH_CNT);

localparam SEC_IN_DAY     = 86400;
localparam LEAP_YEAR_DAYS = 366;
localparam YEAR_DAYS      = 365;
localparam LEAP_YEAR_SECS = LEAP_YEAR_DAYS * SEC_IN_DAY;
localparam YEAR_SECS      = YEAR_DAYS * SEC_IN_DAY;

logic [31:0]       secs_in_cur_year;
logic [31:0]       secs_in_year_tmp;

logic [YEAR_W-1:0] year_tmp;
logic [31:0]       max_secs_year_tmp;

logic [31:0]       secs_before_year_tmp;

logic [31:0]       day_number_of_first_day_in_cur_month;

logic [WEEK_DAYS_W-1:0] first_day_of_cur_month;

logic [YEAR_W-1:0] year;

logic [`MONTH_CNT-1:0][DAY_NUMBER_W-1:0] monthes_days_cnt;
logic [DAY_NUMBER_W-1:0]                 month_days_cnt; 
logic [MONTH_W-1:0] month_tmp;
logic [MONTH_W-1:0] month;

logic [$clog2(LEAP_YEAR_DAYS)-1:0] day_number; 
logic [$clog2(LEAP_YEAR_DAYS)-1:0] days_before_month_tmp;
logic [$clog2(LEAP_YEAR_DAYS)-1:0] day_number_in_month_tmp;
logic [DAY_NUMBER_W-1:0]           day_number_in_month;

// Calcing current year:

always_comb
  begin
    year_tmp             = FIRST_YEAR;
    secs_in_year_tmp     = 'd0;
    secs_before_year_tmp = 'd0;

    for( int i = FIRST_YEAR; i < MAX_YEAR; i++ )
      begin
        secs_in_year_tmp = posix_time_i - secs_before_year_tmp;
        max_secs_year_tmp = ( leap_year( year_tmp ) ) ? ( LEAP_YEAR_SECS ) :
                                                        ( YEAR_SECS      );
        if( secs_in_year_tmp >= max_secs_year_tmp )
          begin
            secs_before_year_tmp = secs_before_year_tmp + max_secs_year_tmp;
            year_tmp             = year_tmp + 1;
          end
        else
          begin
            secs_before_year_tmp = secs_before_year_tmp;
            year_tmp             = year_tmp;
          end
      end
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        year             <= 'd0;
        secs_in_cur_year <= 'd0;
      end
    else
      begin
        year             <= year_tmp;
        secs_in_cur_year <= secs_in_year_tmp;
      end
  end

// Calcing current month  
assign day_number = ( secs_in_cur_year / SEC_IN_DAY );

always_comb
  begin
    monthes_days_cnt[ 0 ]  = `JAN_DAYS_CNT;                            
    monthes_days_cnt[ 1 ]  = ( leap_year( year ) ) ? ( `FEB_LEAP_DAYS_CNT ) : ( `FEB_DAYS_CNT );                           
    monthes_days_cnt[ 2 ]  = `MAR_DAYS_CNT;                      
    monthes_days_cnt[ 3 ]  = `APR_DAYS_CNT;                          
    monthes_days_cnt[ 4 ]  = `MAY_DAYS_CNT;                          
    monthes_days_cnt[ 5 ]  = `JUNE_DAYS_CNT;                         
    monthes_days_cnt[ 6 ]  = `JULY_DAYS_CNT;                         
    monthes_days_cnt[ 7 ]  = `AUG_DAYS_CNT;                          
    monthes_days_cnt[ 8 ]  = `SEPT_DAYS_CNT;                         
    monthes_days_cnt[ 9 ]  = `OCT_DAYS_CNT;                          
    monthes_days_cnt[ 10 ] = `NOV_DAYS_CNT;                          
    monthes_days_cnt[ 11 ] = `DEC_DAYS_CNT;                          
  end

always_comb
  begin
    month_tmp               = 'd0; //YAN
    day_number_in_month_tmp = 'd0;
    days_before_month_tmp   = 'd0;

    for( int i = 0; i < `MONTH_CNT; i++ )
      begin
        day_number_in_month_tmp = day_number - days_before_month_tmp;
        month_days_cnt = monthes_days_cnt[ month_tmp ];

        if( day_number_in_month_tmp >= month_days_cnt )
          begin
            days_before_month_tmp = days_before_month_tmp + month_days_cnt;
            month_tmp = month_tmp + 1;
          end
        else
          begin
            days_before_month_tmp = days_before_month_tmp;
            month_tmp             = month_tmp;
          end
      end
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        month               <= 'd0;
        day_number_in_month <= 'd0;
      end
    else
      begin
        month               <= month_tmp;
        day_number_in_month <= day_number_in_month_tmp;
      end
  end

// Calcing current month first day of week 

assign day_number_of_first_day_in_cur_month = ( ( posix_time_i / SEC_IN_DAY ) - day_number_in_month );
assign first_day_of_cur_month = ( ( day_number_of_first_day_in_cur_month % 7 ) + 3 ) % 7;

// Combining:

assign date_if.month = month;
assign date_if.month_first_day = first_day_of_cur_month;
assign date_if.month_days_cnt = month_days_cnt;
assign date_if.day_in_month = day_number_in_month; 
assign date_if.year = year;

endmodule
