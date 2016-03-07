`define NUM_W 'd80
`define NUM_H 'd100

`define DOT_W 'd10
`define DOT_H 'd10

`define CAL_H 'd307
`define CAL_W 'd308

// Positions:
`define BG      'd0
`define H_LEFT  'd1
`define H_RIGHT 'd2
`define M_LEFT  'd3
`define M_RIGHT 'd4
`define S_LEFT  'd5
`define S_RIGHT 'd6
`define DOT     'd7
`define HDOT    'd8
`define CAL     'd9

`define POS_CNT 'd10

`define L_OFFSET 'd40
`define TOP_OFFSET 'd50
`define CAL_OFFSET 'd166

`define GAP 'd5

`define CAL_GAP 'd20

`define H_TOP_BORDER `TOP_OFFSET
`define H_BOT_BORDER `H_TOP_BORDER + `NUM_H
`define M_TOP_BORDER `TOP_OFFSET
`define M_BOT_BORDER `M_TOP_BORDER + `NUM_H
`define S_TOP_BORDER `TOP_OFFSET
`define S_BOT_BORDER `M_TOP_BORDER + `NUM_H
`define CAL_TOP_BORDER `TOP_OFFSET + `NUM_H + `CAL_GAP
`define CAL_BOT_BORDER `CAL_TOP_BORDER + `CAL_H


`define H_LL_BORDER `L_OFFSET 
`define H_LR_BORDER `L_OFFSET + `NUM_W

`define CUR_POS_HL(x,y) ( ( ( `H_LL_BORDER  <= x ) && ( x < `H_LR_BORDER  ) ) && \
                          ( ( `H_TOP_BORDER <= y ) && ( y < `H_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define H_RL_BORDER `H_LR_BORDER
`define H_RR_BORDER `H_RL_BORDER + `NUM_W

`define CUR_POS_HR(x,y) ( ( ( `H_RL_BORDER  <= x ) && ( x < `H_RR_BORDER  ) ) && \
                          ( ( `H_TOP_BORDER <= y ) && ( y < `H_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define HDOT_L_BORDER `H_RR_BORDER + `GAP
`define HDOT_R_BORDER `HDOT_L_BORDER + `DOT_W

`define HDOT_TOP_BORDER `H_BOT_BORDER - `DOT_H 
`define HDOT_BOT_BORDER `DOT_TOP_BORDER + `DOT_H

`define CUR_POS_HDOT(x,y) ( ( ( `HDOT_L_BORDER   <= x ) && ( x < `HDOT_R_BORDER   ) ) && \
                            ( ( `HDOT_TOP_BORDER <= y ) && ( y < `HDOT_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define M_LL_BORDER `HDOT_R_BORDER + `GAP
`define M_LR_BORDER `M_LL_BORDER + `NUM_W

`define CUR_POS_ML(x,y) ( ( ( `M_LL_BORDER  <= x ) && ( x < `M_LR_BORDER  ) ) && \
                          ( ( `M_TOP_BORDER <= y ) && ( y < `M_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define M_RL_BORDER `M_LR_BORDER
`define M_RR_BORDER `M_RL_BORDER + `NUM_W

`define CUR_POS_MR(x,y) ( ( ( `M_RL_BORDER  <= x ) && ( x < `M_RR_BORDER  ) ) && \
                          ( ( `M_TOP_BORDER <= y ) && ( y < `M_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define DOT_L_BORDER `M_RR_BORDER + `GAP
`define DOT_R_BORDER `DOT_L_BORDER + `DOT_W

`define DOT_TOP_BORDER `H_BOT_BORDER - `DOT_H 
`define DOT_BOT_BORDER `DOT_TOP_BORDER + `DOT_H

`define CUR_POS_DOT(x,y) ( ( ( `DOT_L_BORDER   <= x ) && ( x < `DOT_R_BORDER   ) ) && \
                           ( ( `DOT_TOP_BORDER <= y ) && ( y < `DOT_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define S_LL_BORDER `DOT_R_BORDER + `GAP
`define S_LR_BORDER `S_LL_BORDER + `NUM_W

`define CUR_POS_SL(x,y) ( ( ( `S_LL_BORDER  <= x ) && ( x < `S_LR_BORDER  ) ) && \
                          ( ( `S_TOP_BORDER <= y ) && ( y < `S_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define S_RL_BORDER `S_LR_BORDER 
`define S_RR_BORDER `S_LR_BORDER + `NUM_W 

`define CUR_POS_SR(x,y) ( ( ( `S_RL_BORDER  <= x ) && ( x < `S_RR_BORDER  ) ) && \
                          ( ( `S_TOP_BORDER <= y ) && ( y < `S_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CAL_L_BORDER `CAL_OFFSET
`define CAL_R_BORDER `CAL_L_BORDER + `CAL_W

`define CUR_POS_CAL(x,y) ( ( ( `CAL_L_BORDER   <= x ) && ( x < `CAL_R_BORDER  ) ) && \
                           ( ( `CAL_TOP_BORDER <= y ) && ( y < `CAL_BOT_BORDER ) ) ) ? ( 'd1 ) : ( 'd0 )

`define CUR_POS(x,y) (  ( `CUR_POS_HL(x,y)   ) ? ( `H_LEFT  ) : \
                        ( `CUR_POS_HR(x,y)   ) ? ( `H_RIGHT ) : \
                        ( `CUR_POS_HDOT(x,y) ) ? ( `HDOT    ) : \
                        ( `CUR_POS_ML(x,y)   ) ? ( `M_LEFT  ) : \
                        ( `CUR_POS_MR(x,y)   ) ? ( `M_RIGHT ) : \
                        ( `CUR_POS_DOT(x,y)  ) ? ( `DOT     ) : \
                        ( `CUR_POS_SL(x,y)   ) ? ( `S_LEFT  ) : \
                        ( `CUR_POS_SR(x,y)   ) ? ( `S_RIGHT ) : \
                        ( `CUR_POS_CAL(x,y)  ) ? ( `CAL     ) : \
                        ( `BG                )              )

