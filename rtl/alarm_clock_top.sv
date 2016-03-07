// ============================================================================
// Copyright (c) 2011 by Terasic Technologies Inc. 
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// ============================================================================
// Major Functions/Design Description:
//
//   Please refer to DE0_Nano_User_manual.pdf in DE0_Nano system CD.
//
// ============================================================================
// Revision History:
// ============================================================================
//   Ver.: |Author:   |Mod. Date:    |Changes Made:
//   V1.0  |Keith     |01/15/2011    |
// ============================================================================

//=======================================================
//  This code is generated by Terasic System //=======================================================
//=======================================================

module alarm_clock_top(

//////////// CLOCK //////////
	CLOCK_50,

	//////////// LED //////////
	LED,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SDRAM //////////
	DRAM_ADDR,
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_CKE,
	DRAM_CLK,
	DRAM_CS_N,
	DRAM_DQ,
	DRAM_DQM,
	DRAM_RAS_N,
	DRAM_WE_N,

	//////////// EPCS //////////
	EPCS_ASDO,
	EPCS_DATA0,
	EPCS_DCLK,
	EPCS_NCSO,

	//////////// Accelerometer and EEPROM //////////
	G_SENSOR_CS_N,
	G_SENSOR_INT,
	I2C_SCLK,
	I2C_SDAT,

	//////////// ADC //////////
	ADC_CS_N,
	ADC_SADDR,
	ADC_SCLK,
	ADC_SDAT,

	//////////// 2x13 GPIO Header //////////
	GPIO_2,
	GPIO_2_IN,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	GPIO_0,
	GPIO_0_IN,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	GPIO_1,
	GPIO_1_IN 
);

//=======================================================
//  PARAMETER declarations
//=======================================================

// VGA PARAMETERS

localparam H_DISP   = 640;
localparam H_FPORCH = 16;
localparam H_SYNC   = 96;
localparam H_BPORCH = 48;
localparam V_DISP   = 480;
localparam V_FPORCH = 10;
localparam V_SYNC   = 2;
localparam V_BPORCH = 33;

localparam PIX_X_W = 12; 
localparam PIX_Y_W = 12;


// TIME AND ALARM PARAMETERS

localparam ALARMS_CNT = 7;
localparam GMT        = 3;


// VIRTUAL JTAG PARAMETERS
localparam VJTAG_DATA_W = 32;
localparam IR_W         = 5;


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;

//////////// LED //////////
output		     [7:0]		LED;

//////////// KEY //////////
input 		     [1:0]		KEY;

//////////// SW //////////
input 		     [3:0]		SW;

//////////// SDRAM //////////
output		    [12:0]		DRAM_ADDR;
output		     [1:0]		DRAM_BA;
output		          		DRAM_CAS_N;
output		          		DRAM_CKE;
output		          		DRAM_CLK;
output		          		DRAM_CS_N;
inout 		    [15:0]		DRAM_DQ;
output		     [1:0]		DRAM_DQM;
output		          		DRAM_RAS_N;
output		          		DRAM_WE_N;

//////////// EPCS //////////
output		          		EPCS_ASDO;
input 		          		EPCS_DATA0;
output		          		EPCS_DCLK;
output		          		EPCS_NCSO;

//////////// Accelerometer and EEPROM //////////
output		          		G_SENSOR_CS_N;
input 		          		G_SENSOR_INT;
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;

//////////// ADC //////////
output		          		ADC_CS_N;
output		          		ADC_SADDR;
output		          		ADC_SCLK;
input 		          		ADC_SDAT;

//////////// 2x13 GPIO Header //////////
inout 		    [12:0]		GPIO_2;
input 		     [2:0]		GPIO_2_IN;

//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_0;
input 		     [1:0]		GPIO_0_IN;

//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
inout 		    [33:0]		GPIO_1;
input 		     [1:0]		GPIO_1_IN;


//=======================================================
//  Signal declarations
//=======================================================
//
logic                                clk_25;
logic                                rst;
logic                                rst_w;

logic [ALARMS_CNT-1:0]               alarm;
logic                                alarm_snooze_stb;
logic                                alarm_off_stb;

pixels_if #( .PIX_X_W ( PIX_X_W ),
             .PIX_Y_W ( PIX_Y_W ) )  pixels_if();

vjtag_if  #( .IR_W    ( IR_W    ) )  vjtag_if();


posix_time_ctrl_if                   user_time_if();

posix_time_ctrl_if                   alarm_set_time_if [ALARMS_CNT-1:0] ( );

alarm_ctrl_if                        alarm_ctrl_if();

vga_if                               vga_if();



//=======================================================
//  Structural coding
//=======================================================

rst rst_inst(

  .clk_i  ( CLOCK_50 ),
  .key_i  ( KEY[0]   ),

  .rst_o  ( rst_w    )

);

assign rst = !rst_w;

pll vga_pll(

  .inclk0 ( CLOCK_50 ),
  .c0     ( clk_25   )

);

vga_time_generator vga_time_generator_instance(

  .clk                 ( clk_25         ),
  .reset_n             ( 1'b1           ),

  .h_disp              ( H_DISP         ),
  .h_fporch            ( H_FPORCH       ),
  .h_sync              ( H_SYNC         ),
  .h_bporch            ( H_BPORCH       ),
                              
  .v_disp              ( V_DISP         ),
  .v_fporch            ( V_FPORCH       ),
  .v_sync              ( V_SYNC         ),
  .v_bporch            ( V_BPORCH       ),
  .hs_polarity         ( 1'b0           ),
  .vs_polarity         ( 1'b0           ),
  .frame_interlaced    ( 1'b0           ),
                  
  .vga_hs              ( pixels_if.hs   ),
  .vga_vs              ( pixels_if.vs   ),
  .vga_de              ( pixels_if.de   ),
  .pixel_x             ( pixels_if.x    ),
  .pixel_y             ( pixels_if.y    ),
  .pixel_i_odd_frame   (                )

);

vjtag #(

  .IR_W                ( IR_W                        )

) vjtag (

  .tdi                 ( vjtag_if.tdi                ),  // Data from jtag
  .tdo                 ( vjtag_if.tdo                ),  // Data to jtag 
  .ir_in               ( vjtag_if.ir_in              ),  // Command 
  .ir_out              ( vjtag_if.ir_out             ), 
  .virtual_state_cdr   ( vjtag_if.virtual_state_cdr  ), 
  .virtual_state_sdr   ( vjtag_if.virtual_state_sdr  ), 
  .virtual_state_e1dr  ( vjtag_if.virtual_state_e1dr ), 
  .virtual_state_pdr   ( vjtag_if.virtual_state_pdr  ), 
  .virtual_state_e2dr  ( vjtag_if.virtual_state_e2dr ), 
  .virtual_state_udr   ( vjtag_if.virtual_state_udr  ), // End of data
  .virtual_state_cir   ( vjtag_if.virtual_state_cir  ), 
  .virtual_state_uir   ( vjtag_if.virtual_state_uir  ), 
  .tck                 ( vjtag_if.tck                )  // Output command clk

);

vjtag_to_if #(

  .IR_W                ( IR_W              ),
  .DATA_W              ( VJTAG_DATA_W      ),
  .ALARMS_CNT          ( ALARMS_CNT        )

) vjtag_to_if (

  .clk_i               ( CLOCK_50          ),
  .rst_i               ( rst               ),

  .vjtag_if            ( vjtag_if          ),
  .user_time_if        ( user_time_if      ),
  .alarm_set_time_if   ( alarm_set_time_if )

);

main_alarm_clock #(

  .ALARMS_CNT         ( ALARMS_CNT        )

) main (

  .clk_50_i           ( CLOCK_50          ),
  .clk_25_i           ( clk_25            ),
  .rst_i              ( rst               ),

  .pixels_if          ( pixels_if         ),
  .user_time_if       ( user_time_if      ),
  .alarm_set_time_if  ( alarm_set_time_if ),
  .alarm_ctrl_if      ( alarm_ctrl_if     ),
  .vga_out_if         ( vga_if            ),

  .alarm_o            ( alarm             )

);
            
assign alarm_ctrl_if.alarm_snooze_stb = 1'b0;
assign alarm_ctrl_if.alarm_off_stb = 1'b0;

assign GPIO_1[9]  = ~vga_if.hs;
assign GPIO_1[8]  = ~vga_if.vs;

assign GPIO_1[15] = vga_if.red;
assign GPIO_1[16] = vga_if.green;
assign GPIO_1[17] = vga_if.blue;

assign GPIO_1[10] = 0;
assign GPIO_1[11] = 0;
assign GPIO_1[12] = 0;
assign GPIO_1[13] = 0;
assign GPIO_1[14] = 0;

assign LED[0]   = rst;
assign LED[7:1] = alarm;

endmodule
