`define Y_NUM_W 'd27
`define Y_NUM_H 'd30

`define Y_BG      'd0
`define THOUSANDS 'd1
`define HUNDREDS  'd2
`define DOZENS    'd3
`define UNITS     'd4

`define NUM_POS_CNT 'd5

`define Y_L_OFFSET 'd108

`define THOUSANDS_L_BORDER `Y_L_OFFSET 
`define THOUSANDS_R_BORDER `Y_L_OFFSET + `Y_NUM_W

`define CUR_POS_THOUSANDS(x,y) ( ( ( `THOUSANDS_L_BORDER <= x ) && ( x < `THOUSANDS_R_BORDER ) ) ? \
                                 ( 'd1 ) : ( 'd0 ) )

`define HUNDREDS_L_BORDER `THOUSANDS_R_BORDER 
`define HUNDREDS_R_BORDER `HUNDREDS_L_BORDER + `Y_NUM_W

`define CUR_POS_HUNDREDS(x,y) ( ( ( `HUNDREDS_L_BORDER <= x ) && ( x < `HUNDREDS_R_BORDER ) ) ? \
                                  ( 'd1 ) : ( 'd0 ) )

`define DOZENS_L_BORDER `HUNDREDS_R_BORDER 
`define DOZENS_R_BORDER `DOZENS_L_BORDER + `Y_NUM_W

`define CUR_POS_DOZENS(x,y) ( ( ( `DOZENS_L_BORDER <= x ) && ( x < `DOZENS_R_BORDER ) ) ? \
                                ( 'd1 ) : ( 'd0 ) )

`define UNITS_L_BORDER `DOZENS_R_BORDER 
`define UNITS_R_BORDER `UNITS_L_BORDER + `Y_NUM_W

`define CUR_POS_UNITS(x,y) ( ( ( `UNITS_L_BORDER <= x ) && ( x < `UNITS_R_BORDER ) ) ? \
                               ( 'd1 ) : ( 'd0 ) )

`define CUR_NUM_POS(x,y) (  ( `CUR_POS_THOUSANDS(x,y) ) ? ( `THOUSANDS ) : \
                            ( `CUR_POS_HUNDREDS(x,y)  ) ? ( `HUNDREDS  ) : \
                            ( `CUR_POS_DOZENS(x,y)    ) ? ( `DOZENS    ) : \
                            ( `CUR_POS_UNITS(x,y)     ) ? ( `UNITS     ) : \
                            ( `Y_BG                   )                )

