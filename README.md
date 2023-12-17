## Environment
Code examples are provided on [NASM](https://ru.wikipedia.org/wiki/NASM) for Linux on [x86](https://en.wikipedia.org/wiki/X86).

## Notation
The entry point is the `_start` procedure. </br>

Section order:
  1. `.data`
  2. `.bss`
  3. `.text`

Naming:
- All names are represented in `snake_case`
- A label with a name with an underscore as the first character indicates that the label can only be used once (or that the label is private)

A data section or data declaration can have an invariant declared in a comment. </br>

Non-private labels must have a signature in the form of a comment before declaringthe label, which describes all the parameters in the “type name” format, where the name may be missing, and all the invariants necessary to perform this procedure. Parameters and invariants are delimited by `&`. Return values and resulting invariants are also described, but after the arrow `->` after the input part of the signature. All values are passed through the stack. The order in which values are found on the stack coincides with the order in which their parameters are declared. Input and output data/invariants may be omitted by `*`. </br>

After the signature there should be the word `changes` and all registers and labels that change in the procedure. If there are none, then the word `changes` should not exist either. </br>
