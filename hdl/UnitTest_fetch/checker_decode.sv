/* Checker Unit user for the Instruction Decode
   Author: Shadman Samin, Nikhil Marikal 

   Date: 06/04/2017

   Description: Checker that includes assertions, behaviorial checkers and determinitistic testing for the intruction decode module.
		- State transitions based on the inputs to DUT
		- Reset Functionality
		- Valid Base Address
		- Clearing outputs pdp_mem_opcode, pdp_op7_opcode in specific states mentioned
		- Assertion and de-assertion of read request in specific states mentioned
		- Conversion of instruction of fetched from memory to correct opcode and memory instruction addresses.
		- Correct updat of PC value when out of stall
		- Termination of the execution when PC value equals to pre-defined base address.*/ 
// Package Includee 
`include "pdp8_pkg.sv"

// Package Import
import pdp8_pkg::*;

module checker_decode( 	input logic clk,
			input logic reset_n,
			input logic stall,
			input logic [`ADDR_WIDTH-1:0] PC_value,
			input logic ifu_rd_req,
			input logic [`ADDR_WIDTH-1:0] ifu_rd_addr,
			input logic [`DATA_WIDTH-1:0] ifu_rd_data,
			input logic [`ADDR_WIDTH-1:0] base_addr,
			input pdp_mem_opcode,
			input pdp_op7_opcode  ); 

parameter TRUE = 1; 
parameter FALSE = 0; 
parameter IDLE = 1; 
parameter READY = 2; 
parameter SEND_REQ = 3; 
parameter DATA_RCVD = 4; 
parameter INST_DEC = 5; 
parameter STALL = 6; 
parameter DONE = 7; 



/* Checker Assertions */ 
/* Sequence Defintions:
   |-> :: RHS Evaluation and looked at the @ the same clock edge 
   |=> :: LHS Evaluated and looked at @ the next clock edge 
   ##[X:Y] :: between clocks X and Y
   $isunkown :: returns 1 if output is X or Z 
*/ 
/* disable iff (!reset_n) <- This causes the assertion to always be vacuous */ 

/* Check 1 */
/* When reset is not asserted current should be in IDLE state */ 
property check1; 
	@ (posedge clk) !reset_n |=> top.decode.current_state==IDLE;
endproperty 

/* Check 2 */ 
/* State Transition Coverage based on DUT Input */ 
/* If Reset_n & IDLE is true ready > send request > data received > instruction decode > stall transitions must be true  */ 
property check2;
	@ (posedge clk) (reset_n && (top.decode.current_state==IDLE)) |=> top.decode.current_state==READY |=> top.decode.current_state==SEND_REQ |=> top.decode.current_state==DATA_RCVD |=> top.decode.current_state==INST_DEC |=> top.decode.current_state==STALL;
endproperty  

/* Check 3 */ 
/* State Transtions based on DUT Input */ 
/* If input is stall stay in stall */ 
property check3;
	disable iff (!reset_n)
	@ (posedge clk) ((top.decode.current_state == STALL)  & stall) |=> top.decode.current_state==STALL;
endproperty 


/* Check 4 */ 
/* State Transitions based on DUT Input */
/* If input is not stall and PC_value is not equal to based addr next state must be SEND_REQ */
property check4;
	disable iff (!reset_n)
	@ (posedge clk) ((top.decode.current_state == STALL) & (PC_value != 200)) |=> top.decode.current_state == SEND_REQ; 
endproperty 


/* Check 5 */ 
/* State Transitions based on DUT Input */ 
/* If input is PC_value is equal to base address and current state is stall next state is DONE */ 
property check5;
	disable iff (!reset_n)
	@ (posedge clk) ((PC_value == 200) & (top.decode.current_state == STALL)) |=> DONE; 
endproperty 


/* Check 6 */
/* State Transitions based on DUT Input */ 
/* If in Done state and reset_n is not asserted go into IDLE State */  
property check6; 
	disable iff (!reset_n)
	@ (posedge clk) ((top.decode.current_state == DONE) & (~reset_n) ) |=> (top.decode.current_state == IDLE); 
endproperty 

/* Check 7 */ 
/* Valid Based address */ 
property check7; 
	disable iff (!reset_n)
	@ (posedge clk) !$isunknown(base_addr); 
endproperty 

/* Check 8 */ 
/* Clear Outputs for pdp_mem_opcode in certain states */ 
/* pdp_mem_opcode */
/* If received data top 3 bits is less than 6, we can assume the opcode will assert any of the following memory operation */
property check8; 
	disable iff (!reset_n)
	@ (posedge clk) 
	((ifu_rd_data[`DATA_WIDTH-1:`DATA_WIDTH-3] < 6) && (top.decode.current_state == INST_DEC)) |=> ((top.decode.pdp_mem_opcode.AND == TRUE) || (top.decode.pdp_mem_opcode.TAD == TRUE) || (top.decode.pdp_mem_opcode.ISZ == TRUE) || (top.decode.pdp_mem_opcode.DCA == TRUE) || (top.decode.pdp_mem_opcode.JMS == TRUE) || (top.decode.pdp_mem_opcode.JMP == TRUE));
endproperty

/* Check 9 */ 
/* Clear Outputs for pdp_mem_opcode in certain states */ 
/* pdp_mem_opcode */
/* If received data top 3 bits is less than 6, we can assume the opcode will assert any of the following memory operation */
property check9; 
	disable iff (!reset_n)
	@ (posedge clk) 
	((ifu_rd_data[`DATA_WIDTH-1:`DATA_WIDTH-3] == 7) && (top.decode.current_state == INST_DEC)) |=> ((top.decode.pdp_op7_opcode.NOP == TRUE) || (top.decode.pdp_op7_opcode.IAC == TRUE) || (top.decode.pdp_op7_opcode.RAL == TRUE) || (top.decode.pdp_op7_opcode.RTL == TRUE) || (top.decode.pdp_op7_opcode.RAR == TRUE) || (top.decode.pdp_op7_opcode.RTR == TRUE) || (top.decode.pdp_op7_opcode.CML == TRUE) || (top.decode.pdp_op7_opcode.CMA == TRUE) || (top.decode.pdp_op7_opcode.CIA == TRUE) || (top.decode.pdp_op7_opcode.CLL == TRUE) || (top.decode.pdp_op7_opcode.CLA1 == TRUE) || (top.decode.pdp_op7_opcode.CLA_CLL == TRUE)|| (top.decode.pdp_op7_opcode.HLT == TRUE) || (top.decode.pdp_op7_opcode.OSR == TRUE) || (top.decode.pdp_op7_opcode.SKP == TRUE) || (top.decode.pdp_op7_opcode.SNL == TRUE) || (top.decode.pdp_op7_opcode.SZL == TRUE) || (top.decode.pdp_op7_opcode.SNA == TRUE) || (top.decode.pdp_op7_opcode.SMA == TRUE) || (top.decode.pdp_op7_opcode.SPA == TRUE) || (top.decode.pdp_op7_opcode.CLA2 == TRUE)); 
endproperty
 
 
/* Check 10 */ 
/* Assertion and De-assertion of Read requests in specific state mentioned */ 
/* If in send request state next clk cycle req request should be asserted  */ 
/*
property check10; 
	disable iff (!reset_n)
	@ (posedge clk) 
	(top.decode.current_state == DATA_RCVD) |=> (ifu_rd_req == TRUE); 
endproperty 
*/
 
/* Check 11 */ 
/* Assertion and De-assertion of Read requests in specific state mentioned */ 
/* If not in send request state next clk cycle req request should be asserted low  */ 
property check11; 
	disable iff (!reset_n)
	@ (posedge clk) 
	(top.decode.current_state != DATA_RCVD) |=> (ifu_rd_req == FALSE); 
endproperty 

/* Check 10 */ 
/* Correct update of PC Value when out of stall */ 
/*
property check10; 
	disable iff (!reset_n)
	@ (posedge clk) 
endproperty 
*/


assert_checker1: assert property(check1) else $display("Check 1 Failed"); 
assert_checker2: assert property(check2) else $display("Check 2 Failed"); 
assert_checker3: assert property(check3) else $display("Check 3 Failed"); 
assert_checker4: assert property(check4) else $display("Check 4 Failed"); 
assert_checker5: assert property(check5) else $display("Check 5 Failed"); 
assert_checker6: assert property(check6) else $display("Check 6 Failed"); 
assert_checker7: assert property(check7) else $display("Check 7 Failed"); 
assert_checker8: assert property(check8) else $display("Check 8 Failed"); 
assert_checker9: assert property(check9) else $display("Check 9 Failed"); 
//assert_checker10: assert property(check10) else $display("Check 10 Failed"); 
//assert_checker11: assert property(check11) else $display("Check 11 Failed");  




endmodule

