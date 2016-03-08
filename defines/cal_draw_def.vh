`define LABLE_W 'd298
`define LABLE_H 'd30

`define CELL_W 'd40
`define CELL_H 'd30

// Positions:
`define FRAME 'd0
`define YEAR  'd1
`define MONTH 'd2

`define MON_LABLE 'd3
`define TUE_LABLE 'd4
`define WED_LABLE 'd5
`define THU_LABLE 'd6
`define FRI_LABLE 'd7
`define SAT_LABLE 'd8
`define SUN_LABLE 'd9
`define TABLE     'd10

`define CAL_POS_CNT 'd11

// Dates table content:
`define R0_T0 'd0
`define R0_T1 'd1
`define R0_T2 'd2
`define R0_T3 'd3
`define R0_T4 'd4
`define R0_T5 'd5
`define R0_T6 'd6

`define R1_T0 'd7
`define R1_T1 'd8
`define R1_T2 'd9
`define R1_T3 'd10
`define R1_T4 'd11
`define R1_T5 'd12
`define R1_T6 'd13

`define R2_T0 'd14
`define R2_T1 'd15
`define R2_T2 'd16
`define R2_T3 'd17
`define R2_T4 'd18
`define R2_T5 'd19
`define R2_T6 'd20

`define R3_T0 'd21
`define R3_T1 'd22
`define R3_T2 'd23
`define R3_T3 'd24
`define R3_T4 'd25
`define R3_T5 'd26
`define R3_T6 'd27

`define R4_T0 'd28
`define R4_T1 'd29
`define R4_T2 'd30
`define R4_T3 'd31
`define R4_T4 'd32
`define R4_T5 'd33
`define R4_T6 'd34

`define R5_T0 'd35
`define R5_T1 'd36
`define R5_T2 'd37
`define R5_T3 'd38
`define R5_T4 'd39
`define R5_T5 'd40
`define R5_T6 'd41

`define CELLS_CNT 'd42

`define R0 'd0
`define R1 'd1
`define R2 'd2
`define R3 'd3
`define R4 'd4
`define R5 'd5

`define ROW_CNT 'd6

`define T0 'd0
`define T1 'd1
`define T2 'd2
`define T3 'd3
`define T4 'd4
`define T5 'd5
`define T6 'd6

`define TABLE_CNT 'd7

`define CAL_L_OFFSET 'd5
`define CAL_TOP_OFFSET 'd5

`define FRAME_GAP 'd3

`define YEAR_TOP_BORDER `CAL_TOP_OFFSET
`define YEAR_BOT_BORDER `YEAR_TOP_BORDER + `LABLE_H

`define MONTH_TOP_BORDER `YEAR_BOT_BORDER + `FRAME_GAP
`define MONTH_BOT_BORDER `MONTH_TOP_BORDER + `LABLE_H

`define DAYS_NAMES_TOP_BORDER `MONTH_BOT_BORDER + `FRAME_GAP
`define DAYS_NAMES_BOT_BORDER `DAYS_NAMES_TOP_BORDER + `CELL_H

`define R0_TOP_BORDER `DAYS_NAMES_BOT_BORDER + `FRAME_GAP 
`define R0_BOT_BORDER `R0_TOP_BORDER + `CELL_H 

`define R1_TOP_BORDER `R0_BOT_BORDER + `FRAME_GAP 
`define R1_BOT_BORDER `R1_TOP_BORDER + `CELL_H 

`define R2_TOP_BORDER `R1_BOT_BORDER + `FRAME_GAP                                         
`define R2_BOT_BORDER `R2_TOP_BORDER + `CELL_H                                      

`define R3_TOP_BORDER `R2_BOT_BORDER + `FRAME_GAP                                          
`define R3_BOT_BORDER `R3_TOP_BORDER + `CELL_H                                       

`define R4_TOP_BORDER `R3_BOT_BORDER + `FRAME_GAP                                          
`define R4_BOT_BORDER `R4_TOP_BORDER + `CELL_H                                       

`define R5_TOP_BORDER `R4_BOT_BORDER + `FRAME_GAP                                          
`define R5_BOT_BORDER `R5_TOP_BORDER + `CELL_H                                       

`define YEAR_L_BORDER `CAL_L_OFFSET 
`define YEAR_R_BORDER `YEAR_L_BORDER + `LABLE_W

`define CUR_POS_YEAR(x,y) ( ( ( `YEAR_L_BORDER   <= x ) && ( x < `YEAR_R_BORDER   ) ) && \
                            ( ( `YEAR_TOP_BORDER <= y ) && ( y < `YEAR_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define MONTH_L_BORDER `CAL_L_OFFSET 
`define MONTH_R_BORDER `MONTH_L_BORDER + `LABLE_W

`define CUR_POS_MONTH(x,y) ( ( ( `MONTH_L_BORDER   <= x ) && ( x < `MONTH_R_BORDER   ) ) && \
                             ( ( `MONTH_TOP_BORDER <= y ) && ( y < `MONTH_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_MON_L_BORDER `CAL_L_OFFSET
`define DAYS_NAMES_MON_R_BORDER `DAYS_NAMES_MON_L_BORDER + `CELL_W

`define CUR_POS_MON_LABLE(x,y) ( ( ( `DAYS_NAMES_MON_L_BORDER <= x ) && ( x < `DAYS_NAMES_MON_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_TUE_L_BORDER `DAYS_NAMES_MON_R_BORDER + `FRAME_GAP
`define DAYS_NAMES_TUE_R_BORDER `DAYS_NAMES_TUE_L_BORDER + `CELL_W

`define CUR_POS_TUE_LABLE(x,y) ( ( ( `DAYS_NAMES_TUE_L_BORDER <= x ) && ( x < `DAYS_NAMES_TUE_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_WED_L_BORDER `DAYS_NAMES_TUE_R_BORDER + `FRAME_GAP
`define DAYS_NAMES_WED_R_BORDER `DAYS_NAMES_WED_L_BORDER + `CELL_W
 
`define CUR_POS_WED_LABLE(x,y) ( ( ( `DAYS_NAMES_WED_L_BORDER <= x ) && ( x < `DAYS_NAMES_WED_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_THU_L_BORDER `DAYS_NAMES_WED_R_BORDER + `FRAME_GAP
`define DAYS_NAMES_THU_R_BORDER `DAYS_NAMES_THU_L_BORDER + `CELL_W

`define CUR_POS_THU_LABLE(x,y) ( ( ( `DAYS_NAMES_THU_L_BORDER <= x ) && ( x < `DAYS_NAMES_THU_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_FRI_L_BORDER `DAYS_NAMES_THU_R_BORDER + `FRAME_GAP
`define DAYS_NAMES_FRI_R_BORDER `DAYS_NAMES_FRI_L_BORDER + `CELL_W

`define CUR_POS_FRI_LABLE(x,y) ( ( ( `DAYS_NAMES_FRI_L_BORDER <= x ) && ( x < `DAYS_NAMES_FRI_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_SAT_L_BORDER `DAYS_NAMES_FRI_R_BORDER + `FRAME_GAP
`define DAYS_NAMES_SAT_R_BORDER `DAYS_NAMES_SAT_L_BORDER + `CELL_W

`define CUR_POS_SAT_LABLE(x,y) ( ( ( `DAYS_NAMES_SAT_L_BORDER <= x ) && ( x < `DAYS_NAMES_SAT_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DAYS_NAMES_SUN_L_BORDER `DAYS_NAMES_SAT_R_BORDER + `FRAME_GAP
`define DAYS_NAMES_SUN_R_BORDER `DAYS_NAMES_SUN_L_BORDER + `CELL_W

`define CUR_POS_SUN_LABLE(x,y) ( ( ( `DAYS_NAMES_SUN_L_BORDER <= x ) && ( x < `DAYS_NAMES_SUN_R_BORDER ) ) && \
                                 ( ( `DAYS_NAMES_TOP_BORDER   <= y ) && ( y < `DAYS_NAMES_BOT_BORDER   ) ) ) ? ( 'd1 ) : ( 'd0 )


`define T0_L_BORDER `CAL_L_OFFSET
`define T0_R_BORDER `T0_L_BORDER + `CELL_W

`define CUR_POS_R0_T0(x,y) ( ( ( `T0_L_BORDER   <= x ) && ( x < `T0_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T0(x,y) ( ( ( `T0_L_BORDER   <= x ) && ( x < `T0_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T0(x,y) ( ( ( `T0_L_BORDER   <= x ) && ( x < `T0_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T0(x,y) ( ( ( `T0_L_BORDER   <= x ) && ( x < `T0_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T0(x,y) ( ( ( `T0_L_BORDER   <= x ) && ( x < `T0_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T0(x,y) ( ( ( `T0_L_BORDER   <= x ) && ( x < `T0_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define T1_L_BORDER `T0_R_BORDER + `FRAME_GAP
`define T1_R_BORDER `T1_L_BORDER + `CELL_W

`define CUR_POS_R0_T1(x,y) ( ( ( `T1_L_BORDER   <= x ) && ( x < `T1_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T1(x,y) ( ( ( `T1_L_BORDER   <= x ) && ( x < `T1_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T1(x,y) ( ( ( `T1_L_BORDER   <= x ) && ( x < `T1_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T1(x,y) ( ( ( `T1_L_BORDER   <= x ) && ( x < `T1_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T1(x,y) ( ( ( `T1_L_BORDER   <= x ) && ( x < `T1_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T1(x,y) ( ( ( `T1_L_BORDER   <= x ) && ( x < `T1_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define T2_L_BORDER `T1_R_BORDER + `FRAME_GAP
`define T2_R_BORDER `T2_L_BORDER + `CELL_W

`define CUR_POS_R0_T2(x,y) ( ( ( `T2_L_BORDER   <= x ) && ( x < `T2_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T2(x,y) ( ( ( `T2_L_BORDER   <= x ) && ( x < `T2_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T2(x,y) ( ( ( `T2_L_BORDER   <= x ) && ( x < `T2_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T2(x,y) ( ( ( `T2_L_BORDER   <= x ) && ( x < `T2_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T2(x,y) ( ( ( `T2_L_BORDER   <= x ) && ( x < `T2_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T2(x,y) ( ( ( `T2_L_BORDER   <= x ) && ( x < `T2_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define T3_L_BORDER `T2_R_BORDER + `FRAME_GAP
`define T3_R_BORDER `T3_L_BORDER + `CELL_W

`define CUR_POS_R0_T3(x,y) ( ( ( `T3_L_BORDER   <= x ) && ( x < `T3_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T3(x,y) ( ( ( `T3_L_BORDER   <= x ) && ( x < `T3_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T3(x,y) ( ( ( `T3_L_BORDER   <= x ) && ( x < `T3_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T3(x,y) ( ( ( `T3_L_BORDER   <= x ) && ( x < `T3_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T3(x,y) ( ( ( `T3_L_BORDER   <= x ) && ( x < `T3_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T3(x,y) ( ( ( `T3_L_BORDER   <= x ) && ( x < `T3_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define T4_L_BORDER `T3_R_BORDER + `FRAME_GAP
`define T4_R_BORDER `T4_L_BORDER + `CELL_W

`define CUR_POS_R0_T4(x,y) ( ( ( `T4_L_BORDER   <= x ) && ( x < `T4_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T4(x,y) ( ( ( `T4_L_BORDER   <= x ) && ( x < `T4_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T4(x,y) ( ( ( `T4_L_BORDER   <= x ) && ( x < `T4_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T4(x,y) ( ( ( `T4_L_BORDER   <= x ) && ( x < `T4_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T4(x,y) ( ( ( `T4_L_BORDER   <= x ) && ( x < `T4_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T4(x,y) ( ( ( `T4_L_BORDER   <= x ) && ( x < `T4_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )


`define T5_L_BORDER `T4_R_BORDER + `FRAME_GAP
`define T5_R_BORDER `T5_L_BORDER + `CELL_W

`define CUR_POS_R0_T5(x,y) ( ( ( `T5_L_BORDER   <= x ) && ( x < `T5_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T5(x,y) ( ( ( `T5_L_BORDER   <= x ) && ( x < `T5_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T5(x,y) ( ( ( `T5_L_BORDER   <= x ) && ( x < `T5_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T5(x,y) ( ( ( `T5_L_BORDER   <= x ) && ( x < `T5_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T5(x,y) ( ( ( `T5_L_BORDER   <= x ) && ( x < `T5_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T5(x,y) ( ( ( `T5_L_BORDER   <= x ) && ( x < `T5_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )


`define T6_L_BORDER `T5_R_BORDER + `FRAME_GAP
`define T6_R_BORDER `T6_L_BORDER + `CELL_W

`define CUR_POS_R0_T6(x,y) ( ( ( `T6_L_BORDER   <= x ) && ( x < `T6_R_BORDER   ) ) && \
                             ( ( `R0_TOP_BORDER <= y ) && ( y < `R0_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R1_T6(x,y) ( ( ( `T6_L_BORDER   <= x ) && ( x < `T6_R_BORDER   ) ) && \
                             ( ( `R1_TOP_BORDER <= y ) && ( y < `R1_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R2_T6(x,y) ( ( ( `T6_L_BORDER   <= x ) && ( x < `T6_R_BORDER   ) ) && \
                             ( ( `R2_TOP_BORDER <= y ) && ( y < `R2_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R3_T6(x,y) ( ( ( `T6_L_BORDER   <= x ) && ( x < `T6_R_BORDER   ) ) && \
                             ( ( `R3_TOP_BORDER <= y ) && ( y < `R3_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R4_T6(x,y) ( ( ( `T6_L_BORDER   <= x ) && ( x < `T6_R_BORDER   ) ) && \
                             ( ( `R4_TOP_BORDER <= y ) && ( y < `R4_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS_R5_T6(x,y) ( ( ( `T6_L_BORDER   <= x ) && ( x < `T6_R_BORDER   ) ) && \
                             ( ( `R5_TOP_BORDER <= y ) && ( y < `R5_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )


`define CUR_POS_TABLE(x,y) ( ( `CUR_POS_R0_T0(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R0_T1(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R0_T2(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R0_T3(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R0_T4(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R0_T5(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R0_T6(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T0(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T1(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T2(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T3(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T4(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T5(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R1_T6(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T0(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T1(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T2(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T3(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T4(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T5(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R2_T6(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T0(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T1(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T2(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T3(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T4(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T5(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R3_T6(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T0(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T1(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T2(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T3(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T4(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T5(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R4_T6(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T0(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T1(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T2(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T3(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T4(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T5(x,y) ) ? ( 'd1 ) : \
                             ( `CUR_POS_R5_T6(x,y) ) ? ( 'd1 ) : \
                             ( 'd0                 )         )

`define CUR_POS_CAL(x,y) (  ( `CUR_POS_YEAR(x,y)      ) ? ( `YEAR      ) : \
                        ( `CUR_POS_MONTH(x,y)     ) ? ( `MONTH     ) : \
                        ( `CUR_POS_MON_LABLE(x,y) ) ? ( `MON_LABLE ) : \
                        ( `CUR_POS_TUE_LABLE(x,y) ) ? ( `TUE_LABLE ) : \
                        ( `CUR_POS_WED_LABLE(x,y) ) ? ( `WED_LABLE ) : \
                        ( `CUR_POS_THU_LABLE(x,y) ) ? ( `THU_LABLE ) : \
                        ( `CUR_POS_FRI_LABLE(x,y) ) ? ( `FRI_LABLE ) : \
                        ( `CUR_POS_SAT_LABLE(x,y) ) ? ( `SAT_LABLE ) : \
                        ( `CUR_POS_SUN_LABLE(x,y) ) ? ( `SUN_LABLE ) : \
                        ( `CUR_POS_TABLE(x,y)     ) ? ( `TABLE     ) : \
                        ( `FRAME                  )                )

`define CUR_ROW(x,y) ( ( `CUR_POS_R0_T0(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R0_T1(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R0_T2(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R0_T3(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R0_T4(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R0_T5(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R0_T6(x,y) ) ? ( `R0 ) : \
                       ( `CUR_POS_R1_T0(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R1_T1(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R1_T2(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R1_T3(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R1_T4(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R1_T5(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R1_T6(x,y) ) ? ( `R1 ) : \
                       ( `CUR_POS_R2_T0(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R2_T1(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R2_T2(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R2_T3(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R2_T4(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R2_T5(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R2_T6(x,y) ) ? ( `R2 ) : \
                       ( `CUR_POS_R3_T0(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R3_T1(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R3_T2(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R3_T3(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R3_T4(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R3_T5(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R3_T6(x,y) ) ? ( `R3 ) : \
                       ( `CUR_POS_R4_T0(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R4_T1(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R4_T2(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R4_T3(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R4_T4(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R4_T5(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R4_T6(x,y) ) ? ( `R4 ) : \
                       ( `CUR_POS_R5_T0(x,y) ) ? ( `R5 ) : \
                       ( `CUR_POS_R5_T1(x,y) ) ? ( `R5 ) : \
                       ( `CUR_POS_R5_T2(x,y) ) ? ( `R5 ) : \
                       ( `CUR_POS_R5_T3(x,y) ) ? ( `R5 ) : \
                       ( `CUR_POS_R5_T4(x,y) ) ? ( `R5 ) : \
                       ( `CUR_POS_R5_T5(x,y) ) ? ( `R5 ) : \
                       ( `CUR_POS_R5_T6(x,y) ) ? ( `R5 ) : \
                       ( 'd0                 )            )


`define CUR_TABLE(x,y) ( ( `CUR_POS_R0_T0(x,y) ) ? ( `T0 ) : \
                         ( `CUR_POS_R0_T1(x,y) ) ? ( `T1 ) : \
                         ( `CUR_POS_R0_T2(x,y) ) ? ( `T2 ) : \
                         ( `CUR_POS_R0_T3(x,y) ) ? ( `T3 ) : \
                         ( `CUR_POS_R0_T4(x,y) ) ? ( `T4 ) : \
                         ( `CUR_POS_R0_T5(x,y) ) ? ( `T5 ) : \
                         ( `CUR_POS_R0_T6(x,y) ) ? ( `T6 ) : \
                         ( `CUR_POS_R1_T0(x,y) ) ? ( `T0 ) : \
                         ( `CUR_POS_R1_T1(x,y) ) ? ( `T1 ) : \
                         ( `CUR_POS_R1_T2(x,y) ) ? ( `T2 ) : \
                         ( `CUR_POS_R1_T3(x,y) ) ? ( `T3 ) : \
                         ( `CUR_POS_R1_T4(x,y) ) ? ( `T4 ) : \
                         ( `CUR_POS_R1_T5(x,y) ) ? ( `T5 ) : \
                         ( `CUR_POS_R1_T6(x,y) ) ? ( `T6 ) : \
                         ( `CUR_POS_R2_T0(x,y) ) ? ( `T0 ) : \
                         ( `CUR_POS_R2_T1(x,y) ) ? ( `T1 ) : \
                         ( `CUR_POS_R2_T2(x,y) ) ? ( `T2 ) : \
                         ( `CUR_POS_R2_T3(x,y) ) ? ( `T3 ) : \
                         ( `CUR_POS_R2_T4(x,y) ) ? ( `T4 ) : \
                         ( `CUR_POS_R2_T5(x,y) ) ? ( `T5 ) : \
                         ( `CUR_POS_R2_T6(x,y) ) ? ( `T6 ) : \
                         ( `CUR_POS_R3_T0(x,y) ) ? ( `T0 ) : \
                         ( `CUR_POS_R3_T1(x,y) ) ? ( `T1 ) : \
                         ( `CUR_POS_R3_T2(x,y) ) ? ( `T2 ) : \
                         ( `CUR_POS_R3_T3(x,y) ) ? ( `T3 ) : \
                         ( `CUR_POS_R3_T4(x,y) ) ? ( `T4 ) : \
                         ( `CUR_POS_R3_T5(x,y) ) ? ( `T5 ) : \
                         ( `CUR_POS_R3_T6(x,y) ) ? ( `T6 ) : \
                         ( `CUR_POS_R4_T0(x,y) ) ? ( `T0 ) : \
                         ( `CUR_POS_R4_T1(x,y) ) ? ( `T1 ) : \
                         ( `CUR_POS_R4_T2(x,y) ) ? ( `T2 ) : \
                         ( `CUR_POS_R4_T3(x,y) ) ? ( `T3 ) : \
                         ( `CUR_POS_R4_T4(x,y) ) ? ( `T4 ) : \
                         ( `CUR_POS_R4_T5(x,y) ) ? ( `T5 ) : \
                         ( `CUR_POS_R4_T6(x,y) ) ? ( `T6 ) : \
                         ( `CUR_POS_R5_T0(x,y) ) ? ( `T0 ) : \
                         ( `CUR_POS_R5_T1(x,y) ) ? ( `T1 ) : \
                         ( `CUR_POS_R5_T2(x,y) ) ? ( `T2 ) : \
                         ( `CUR_POS_R5_T3(x,y) ) ? ( `T3 ) : \
                         ( `CUR_POS_R5_T4(x,y) ) ? ( `T4 ) : \
                         ( `CUR_POS_R5_T5(x,y) ) ? ( `T5 ) : \
                         ( `CUR_POS_R5_T6(x,y) ) ? ( `T6 ) : \
                         ( 'd0                 )            )


