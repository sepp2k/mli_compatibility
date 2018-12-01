open Ocaml_common

let parse_mli file =
  let in_chan = open_in file in
  let lexbuf = Lexing.from_channel in_chan in
  let ast = Parser.interface Lexer.token lexbuf in
  Pprintast.signature Format.std_formatter ast;
  Format.print_newline ();
  close_in in_chan;
  ast

let () =
    if Array.length Sys.argv <> 3
    then begin
        Printf.eprintf "Usage: %s file1.mli file2.mli\n" Sys.argv.(0);
        exit 1
    end

let () = Lexer.init()
let ast1 = parse_mli Sys.argv.(1)
let ast2 = parse_mli Sys.argv.(2)
