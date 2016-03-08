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

  input                   clk_i,
  input                   rst_i,
  
  posix_time_ctrl_if.in  posix_time_if,

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

logic [31:0]       posix_time;

logic [31:0]       secs_in_year_tmp;

logic [YEAR_W-1:0] year_tmp;
logic [31:0]       max_secs_year_tmp;

logic [31:0]       secs_before_year_tmp;

logic [31:0]       day_number_of_first_day_in_cur_month;

logic [WEEK_DAYS_W-1:0] first_day_of_cur_month;

logic               posix_time_new;

logic [`MONTH_CNT-1:0][DAY_NUMBER_W-1:0] monthes_days_cnt;
logic [DAY_NUMBER_W-1:0]                 month_days_cnt; 
logic [MONTH_W-1:0] month_tmp;
logic [$clog2(LEAP_YEAR_DAYS)-1:0] day_number; 
logic [$clog2(LEAP_YEAR_DAYS)-1:0] days_before_month_tmp;
logic [$clog2(LEAP_YEAR_DAYS)-1:0] day_number_in_month_tmp;
logic [DAY_NUMBER_W-1:0]           day_number_in_month;

logic valid_year;
// Calcing current year:

assign max_secs_year_tmp = ( leap_year( year_tmp ) ) ? ( LEAP_YEAR_SECS ) :
                                                       ( YEAR_SECS      );


assign secs_in_year_tmp  = ( posix_time - secs_before_year_tmp );


assign posix_time = posix_time_if.usr_posix_time;

assign posix_time_new = posix_time_if.usr_posix_time_en;

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        year_tmp             <= FIRST_YEAR;
        secs_before_year_tmp <= 'd0;
        valid_year           <= 1'b0;
      end
    else
      begin
        if( posix_time_new )
          begin
            secs_before_year_tmp <= 'd0;
            year_tmp             <= FIRST_YEAR;
            valid_year           <= 1'b0;
          end
        else
          begin
            if( secs_in_year_tmp >= max_secs_year_tmp )
              begin
                secs_before_year_tmp <= secs_before_year_tmp + max_secs_year_tmp;
                year_tmp             <= year_tmp + 1;
                valid_year           <= 1'b0;
              end
            else
              begin
                secs_before_year_tmp <= secs_before_year_tmp;
                year_tmp             <= year_tmp;
                valid_year           <= 1'b1;
              end
          end
      end
  end

// Calcing current month  
assign day_number = ( secs_in_year_tmp / SEC_IN_DAY );

always_comb
  begin
    monthes_days_cnt[ 0 ]  = `JAN_DAYS_CNT;                            
    monthes_days_cnt[ 1 ]  = ( leap_year( year_tmp ) ) ? ( `FEB_LEAP_DAYS_CNT ) : ( `FEB_DAYS_CNT );                           
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


assign month_days_cnt          = monthes_days_cnt[ month_tmp ];
assign day_number_in_month_tmp = ( day_number - days_before_month_tmp );

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        month_tmp               <= 'd0; //YAN
        days_before_month_tmp   <= 'd0;
      end
    else
      begin
        if( !valid_year )
          begin
            month_tmp               <= 'd0; //YAN
            days_before_month_tmp   <= 'd0;
          end
        else
          begin
            if( day_number_in_month_tmp >= month_days_cnt )
              begin
                days_before_month_tmp <= days_before_month_tmp + month_days_cnt;
                month_tmp             <= month_tmp + 1;
              end
            else
              begin
                days_before_month_tmp <= days_before_month_tmp;
                month_tmp             <= month_tmp;
              end
          end
      end
  end

assign day_number_in_month = day_number_in_month_tmp;

// Calcing current month first day of week 

assign day_number_of_first_day_in_cur_month = ( ( posix_time / SEC_IN_DAY ) - day_number_in_month );
assign first_day_of_cur_month = ( ( day_number_of_first_day_in_cur_month % 7 ) + 3 ) % 7;

// Combining:

assign date_if.month = month_tmp;
assign date_if.month_first_day = first_day_of_cur_month;
assign date_if.month_days_cnt = month_days_cnt;
assign date_if.day_in_month = day_number_in_month; 
assign date_if.year = year_tmp;

endmodule
