# l-system-sequencer

a [D0L-system sequencer](https://www-archiv.fdm.uni-hamburg.de/b-online/e28_3/lsys.html) i built using [PedroAlvesV/LuaMidi](https://github.com/PedroAlvesV/LuaMidi)

## usage

the sequencer functions by taking an input in the terminal and outputting a modified version to a file named in `config.lua`. `config.lua` is used to configure the rules for sequence generation and the name of the output file. modifying rules is one of the many ways to modify the output of the program.

when the program is running, the primary ways to modify the output are to use varying initial patterns and vary the number of iterations. varying the number of iterations GREATLY affects the length of the output sequence when used in sequence mode.

here's an example of what the program looks like when it runs:

```
enter starting pattern (A-G)
>CEGCEG
how many iterations?
>3
enter 1 for chord, 0 for sequence
>0
output pattern:
CDDEDEEFEFFGFGGAGAABABBCCDDEDEEFEFFGFGGAGAABABBC
rules used:
AB
BC
CD
DE
EF
FG
GA


successfully output to output/gen.mid
```

*`>` in this case represents a user input line*



if you encounter any problems, please don't hesitate to [contact]([card](https://mote.moe/card)) me or report an issue in this repository.
