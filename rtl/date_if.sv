// Месяцы начинаются с 0-го
// Год такой, какой есть
// Дни недели:
//  0 - Пн
//  1 - Вт
//  2 - Ср
//  3 - Чт
//  4 - Пт
//  5 - Сб
//  6 - Вс

// Число дней в месяце - как есть.

interface date_if;

  logic  [$clog2(12)-1:0]    month;
  logic  [$clog2(7)-1:0]     month_first_day;
  logic  [$clog2(31)-1:0]    month_days_cnt;

  logic  [$clog2(31)-1:0]    day_in_month;

  logic  [$clog2(3000)-1:0]  year;


modport in(

  input  month,
  input  month_first_day,
  input  month_days_cnt,
  input  day_in_month,
  input  year

); 

modport out(

  output  month,
  output  month_first_day,
  output  month_days_cnt,
  output  day_in_month,
  output  year

); 

endinterface
