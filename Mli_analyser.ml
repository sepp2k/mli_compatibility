open Ocaml_common
open Parsetree

module StringMap = Map.Make(String)

let parse_mli file =
    let in_chan = open_in file in
    let lexbuf = Lexing.from_channel in_chan in
    let ast = Parser.interface Lexer.token lexbuf in
    close_in in_chan;
    ast

let create_map (f: 'a -> (string * 'b) option) (xs: 'a list): 'b StringMap.t =
    let folder acc x =
        match f x with
        | Some (key, value) -> StringMap.add key value acc
        | None -> acc
    in
    List.fold_left folder StringMap.empty xs

let () =
    if Array.length Sys.argv <> 3
    then begin
        Printf.eprintf "Usage: %s file1.mli file2.mli\n" Sys.argv.(0);
        exit 1
    end

let () = Lexer.init()
let ast1 = parse_mli Sys.argv.(1)
let ast2 = parse_mli Sys.argv.(2)
let get_name_and_type_of_val (item: signature_item): (string * core_type) option =
    match item.psig_desc with
    | Psig_value value_desc -> Some (value_desc.pval_name.txt, value_desc.pval_type)
    | _ -> None

let file1_val_names_to_types = create_map get_name_and_type_of_val ast1
let () = StringMap.iter (fun name typ -> Format.printf "%s: %a@." name Pprintast.core_type typ) file1_val_names_to_types