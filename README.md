# mli_compatibility
Check two mli files for definitions with compatible signatures

### Building
Run `dune build`. The generated executable will then be in `./_build/default/mli_analyser.exe`.

### Usage

    mli_analyser.exe file1.mli file2.mli

This will currently print the types of any value declared in both mli files.

### Example Usage

    # ./_build/default/mli_analyser.exe examples/foo1.mli examples/foo2.mli
    f: 'a list -> int -> ('a -> 'b) -> 'b  VS  'a list -> int -> ('a -> 'b) -> 'b
    g: int -> int  VS  'a -> 'a
    h: int -> int  VS  int -> int
