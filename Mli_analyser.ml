open Ocaml_common;;

let lexbuf = Lexing.from_string "val f: 'a list -> int -> ('a -> 'b) -> 'b" in
Lexer.init();
let parsetree = Parser.interface Lexer.token lexbuf in
Pprintast.signature Format.std_formatter parsetree;
Format.print_newline ()
