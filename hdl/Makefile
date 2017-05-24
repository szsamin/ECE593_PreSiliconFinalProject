all: setlib compile run

setlib: vlib work
	vmap work work

compile: vlog -sv 

run: vsim -c work.test -l SIM.log -do "run -all; quit" 
