open Ocaml_common
open Parsetree
open Core

let parse_mli file =
    In_channel.with_file file ~binary:false ~f:(fun in_file ->
        let lexbuf = Lexing.from_channel in_file in
        Parser.interface Lexer.token lexbuf
    )

type ('k, 'v) map = ('k, 'v) Map.Poly.t

let create_map (f: 'a -> ('k * 'v) option) (xs: 'a list): ('k, 'v) map =
    let folder acc x =
        match f x with
        | Some (key, value) ->
            begin match Map.add acc ~key ~data:value with
            | `Ok result -> result
            | `Duplicate -> failwith "Duplicate key in map creation"
            end
        | None -> acc
    in
    List.fold_left ~f:folder ~init:Map.Poly.empty xs

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

let file1_types = create_map get_name_and_type_of_val ast1
let file2_types = create_map get_name_and_type_of_val ast2
let () = Map.iter2 file1_types file2_types ~f:(fun ~key:name ~data ->
    match data with
    | `Both (type1, type2) ->
        Format.printf "%s: %a  VS  %a@." name Pprintast.core_type type1 Pprintast.core_type type2
    | _ -> ()
)