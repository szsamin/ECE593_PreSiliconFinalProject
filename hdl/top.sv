/* Top SV */ 

// Package Includee 
`include "pdp8_pkg.sv"

// Package Import
import pdp8_pkg::*;

module top; 

// For Clk gen
logic clk;
logic reset_n; 


// From Execution to Instruction 
logic stall; 
logic [`ADDR_WIDTH-1:0] PC_value; 

// Fetch declarations 
logic 			ifu_rd_req; 
logic [`ADDR_WIDTH-1:0] ifu_rd_addr; 
logic [`DATA_WIDTH-1:0] ifu_rd_data; 
 
// Base address
logic [`ADDR_WIDTH-1:0] base_addr; 

// Decode Struct Declaration 
pdp_mem_opcode_s pdp_mem_opcode; 
pdp_op7_opcode_s pdp_op7_opcode; 

// Execute declaration 
logic 			exec_wr_req; 
logic 			exec_rd_req; 

logic [`ADDR_WIDTH-1:0] exec_wr_addr;
logic [`ADDR_WIDTH-1:0] exec_rd_addr;

logic [`DATA_WIDTH-1:0] exec_wr_data; 
logic [`DATA_WIDTH-1:0] exec_rd_data; 

// Clock Generator Instantiation
clkgen_driver clk_1(
			.clk(clk),
			.reset_n(reset_n)
);

// Execute Module Instantiation
instr_decode decode(
			.clk(clk),
			.reset_n(reset_n),
			.stall(stall),
			.PC_value(PC_value),
			.ifu_rd_req(ifu_rd_req),
			.ifu_rd_addr(ifu_rd_addr),
			.ifu_rd_data(ifu_rd_data),
			.base_addr(base_addr),
			.pdp_mem_opcode(pdp_mem_opcode),
			.pdp_op7_opcode(pdp_op7_opcode)
);


// Execute Module
instr_exec execute(
			.clk(clk),
			.reset_n(reset_n),
			.base_addr(base_addr),
			.pdp_mem_opcode(pdp_mem_opcode),
			.pdp_op7_opcode(pdp_op7_opcode),
			.stall(stall),
			.PC_value(PC_value),
			.exec_wr_req(exec_wr_req),
			.exec_wr_addr(exec_wr_addr),
			.exec_rd_req(exec_rd_req),
			.exec_rd_data(exec_rd_data),
			.exec_rd_addr(exec_rd_addr),
			.exec_wr_data(exec_wr_data)
);














endmodule
