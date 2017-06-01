/* Memory Test 
   Author: Nitish, Shadman
   Date: 06/01/2017

   Description: Deterministic unit testing for memory operations
	        1) Read after Read -- Random location, fixed locations
		2) Writes after Writes -- Random location, fixed locations 
		3) Read after Writes --- Random location, fixed locations
		4) Write after Reads -- Random locations, fixed locations
		5) Valid Memory addressing
		6) No parallel read requests from intruction fetch and decode unit and execution unit


*/ 

// Package Include
`include "pdp8_pkg.sv"

// Package Import
import pdp8_pkg::*; 


module memoryTest;

// Global Clock Input
logic clk;
logic reset_n; 

// Fetch Declarations
logic 			ifu_rd_req; 
logic [`ADDR_WIDTH-1:0] ifu_rd_addr;
logic ['DATA_WIDTH-1:0] ifu_rd_data; 

// Execute Declarations 
logic 			exec_rd_req;
logic [`ADDR_WIDTH-1:0] exec_rd_addr;
logic [`DATA_WIDTH-1:0]	exec_rd_data;

logic 			exec_wr_req;
logic [`ADDR_WIDTH-1:0] exec_wr_addr;
logic [`DATA_WIDTH-1:0] exec_wr_data; 

// Clk Generator 
clkgen_driver(
		.clk(clk), 
		.reset_n(reset_n) 
);

// Read after Read
task rd_rd(); 
endtask

// Write after Write
task wr_wr(); 
endtask

// Read after Write
task rd_wr(); 
endtask 

// Write after Read
task wr_rd(); 
endtask 

// Deterministic testing Stimulus generator 
initial begin 



end
endmodule 
