# Fourier (envelope extraction) IP-core for Lattice ICE40UP5K

## Simulation

### Modelsim

* Go to the ```sim/modelsim``` directory
* Run in a terminal ```vsim -do tb_xxx.do```, where tb_xxx is the name of the testbench (e.g. ```vsim -do tb_demo.do```).

### Icarus + GTKWave

* Go to the ```sim/icarus``` directory
* Run in a terminal ```./run_sim tb_xxx```, where tb_xxx is the name of the testbench (e.g. ```./run_sim -do tb_demo```).

## Implementation

### Radiant

* Open ```.rdf``` project in the ```impl/radiant``` directory
* Use GUI for synthesis, map and place and route

### Icestrom (yosys + nextpnr)

* Go to the ```impl/icestorm``` directory
* Run in a terminal ```./run_impl```. Synthesis, place and route and static timing analysis will be executed.