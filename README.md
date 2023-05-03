# cm-chip-hdl
A hardware description of the Connection Machine's chip, written in Verilog

## A Brief History
The Connection Machine was a supercomputer designed by Dnaile Hillis for his PhD thesis in 1985.
Apparently only 7 were actually built. This code is a "sketch" hardware description of the "chip," the
building block of the machine containing 16 processing cells and a router for inter processor
communication, for the purposes of preservation

## How Do I Connect the Machine?
This Verilog probably won't work out of the box. If you're implementing this on an FPGA, you'll need to
mess around in `top.v` to connect up the inputs and outputs to the right place, and figure out how to
jerryrig RAM into the thing. But all the stuff related to the Connection Machine is there, so if you know
enough about Verilog and not much about the Connection Machine you _should_ be able to figure out how to
build a replica from this if you wanted to.
