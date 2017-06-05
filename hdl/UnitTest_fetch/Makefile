all: setlib compile run

setlib: 
	vlib work


compile: 
	vlog top.sv clkgen_driver.sv instr_decode.sv memory_pdp.sv checker_decode.sv  

run: 
	vsim -c work.top -l unitTest_decode.log -do "run -all; quit" 
