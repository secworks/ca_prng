# ca_prng
Cellular Automata based PRNG

## Status
Completed and tested in FPGA.

## Introduction
This core is a simple pseudo random number generator (PRNG) based on
cellular automata. Given an 32-bit input pattern, and an 8-bit update
rule the core will generate a sequence of 32-bit patterns. The default
update rule is [Rule 30](https://en.wikipedia.org/wiki/Rule_30).


## Implementation
The implementation will generate a new pattern each cycle. The update
logic is simple and allows for high clock speed.
