interface vjtag_if;

parameter IR_W = 3;

  logic            tdo;    // data to jtag
  logic [IR_W-1:0] ir_out; // command to jtag

  logic            tck;   // jtag test clock (all signals on this clock
  logic            tdi;   // data from jtag 
  logic [IR_W-1:0] ir_in; // command from jtag

  logic            virtual_state_cdr;  // jtag in campture DR state
  logic            virtual_state_sdr;  // jtag in shift DR state
  logic            virtual_state_e1dr; // jtag in exit 1dr state
  logic            virtual_state_pdr;  // jtag in puse state
  logic            virtual_state_e2dr; // jtag in exit 2dr state
  logic            virtual_state_udr;  // jtag in update DR state
  logic            virtual_state_cir;  // jtag in capture IR state
  logic            virtual_state_uir;  // jtag in update IR state

modport in(

output tdo,
       ir_out,

input  tck,
       tdi, 
       ir_in,

       virtual_state_cdr,
       virtual_state_sdr, 
       virtual_state_e1dr,
       virtual_state_pdr, 
       virtual_state_e2dr,
       virtual_state_udr, 
       virtual_state_cir, 
       virtual_state_uir 

);

modport out(

input  tdo,
       ir_out,

output tck,
       tdi, 
       ir_in,

       virtual_state_cdr,
       virtual_state_sdr, 
       virtual_state_e1dr,
       virtual_state_pdr, 
       virtual_state_e2dr,
       virtual_state_udr, 
       virtual_state_cir, 
       virtual_state_uir 

); 

endinterface
