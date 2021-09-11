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


## FuseSoC
This core is supported by the
[FuseSoC](https://github.com/olofk/fusesoc) core package manager and
build system. Some quick  FuseSoC instructions:

Install FuseSoC
~~~
pip install fusesoc
~~~

Create and enter a new workspace
~~~
mkdir workspace && cd workspace
~~~

Register ca_prng as a library in the workspace
~~~
fusesoc library add ca_prng /path/to/ca_prng
~~~
...if repo is available locally or...
...to get the upstream repo
~~~
fusesoc library add ca_prng https://github.com/secworks/ca_prng
~~~

Run tb_ca_prng testbench
~~~
fusesoc run --target=tb_ca_prng secworks:crypto:ca_prng
~~~

Run with modelsim instead of default tool (icarus)
~~~
fusesoc run --target=tb_ca_prng --tool=modelsim secworks:crypto:ca_prng
~~~
