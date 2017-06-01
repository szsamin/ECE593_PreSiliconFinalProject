all: setlib compile run

setlib: 
	vlib work


compile: 
	vlog *.sv 

run: 
	vsim -c work.top -l SIM.log -do "run -all; quit" 
