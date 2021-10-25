(* GLOBAL HELPERS *)
let get_line _ =
  read_line () |> String.split_on_char ' ' |> List.map int_of_string

(* Read First line and store n & k *)
let line_one_data : int list = get_line ()

let n : int = line_one_data |> List.hd

let k : int = line_one_data |> List.tl |> List.hd

(* Adjacency Matrix *)
let graph : int list array = Array.make (n + k) []

let arr_list_append (idx : int) (valu : int) =
  graph.(idx) <- valu :: graph.(idx)

(* Fill adjacency matrix (input lines 2...[2+n]) *)
let () =
  for candidate = 0 to n - 1 do
    let rec iter_revs recs () () =
      match recs with
      | [] -> ()
      | h :: t ->
          iter_revs t
            (arr_list_append candidate h)
            (arr_list_append h candidate)
    in
    iter_revs (get_line ()) () ()
  done

(* An array of k length that stores the recruiter's capacities could be
   improved with a class for safer access *)
let capacities = Array.of_list (get_line ())

(* Gets the capacity for a particular recruiter [correctly maps the
   capacities array] *)
let get_capacity recruiter =
  if recruiter < n then raise (failwith "Invalid Recruiter Number")
  else capacities.(recruiter - n)

(* The final line of input. The index is the candidate and the value is
   the recuirter intervewing that candidate *)
let recruiters =
  Array.append (Array.of_list (get_line ())) (Array.make 1 ~-1)

(* An array which ignores the first n-1 entries and tracks the filled
   capacities of recruiters at their given index*)
let rec_capacities_filled = Array.make (n + k) 0

let () =
  Array.iter
    (fun recruiter ->
      if recruiter < 0 then ()
      else
        let cap = rec_capacities_filled.(recruiter) in
        rec_capacities_filled.(recruiter) <- cap + 1)
    recruiters

(* Helper that returns true if a recruiter's capacity is full *)
let is_recruiter_full recruiter =
  if recruiter < n then raise (failwith "Invalid recruiter number")
  else if get_capacity recruiter > rec_capacities_filled.(recruiter)
  then false
  else true

(* TRACKER VALUES FOR DFS/FORD-FULKERSON [dfs_ff] FUNCTION *)
let visited = Array.make (n + k) false

let prev_nodes = Array.make (n + k) ~-1

let stack = Stack.create ()

let () = Stack.push (n - 1) stack

let answer_node = Array.make 1 ~-1

let is_not_visited node = if visited.(node) then false else true
(* END TRACKER VALUES *)

(* [dfs_ff] Helpers *)
let is_recruiter node = if node >= n then true else false

let update_recruiters current_node =
  let curr = Array.make 1 current_node in
  while curr.(0) != n - 1 do
    let () =
      if is_recruiter curr.(0) then
        recruiters.(prev_nodes.(curr.(0))) <- curr.(0)
    in
    curr.(0) <- prev_nodes.(curr.(0))
  done

let update_prev_nodes child current_node =
  prev_nodes.(child) <- current_node

let update_answer_node current_node = answer_node.(0) <- current_node
(* END [dfs_ff] trackers *)

let dfs_ff =
  while Stack.length stack > 0 do
    let current_node = Stack.pop stack in
    let () = visited.(current_node) <- true in
    List.iter
      (fun child ->
        match current_node with
        | _ when is_recruiter current_node ->
            (* If is a recruiter *)
            let () =
              if is_recruiter_full current_node then ()
              else
                let () = update_answer_node current_node in
                update_recruiters current_node
            in
            if recruiters.(child) = current_node && is_not_visited child
            then
              let () = update_prev_nodes child current_node in
              Stack.push child stack
            else ()
        | _ ->
            (* If is a Candidate *)
            if
              recruiters.(current_node) != child && is_not_visited child
            then
              let () = update_prev_nodes child current_node in
              Stack.push child stack)
      graph.(current_node)
  done

(* Print Yes if there exists a full assignment else then No *)
let () = print_endline (if answer_node.(0) != ~-1 then "Yes" else "No")

let compiled_print_arr =
  Array.map (fun x -> if x then '1' else '0') (Array.sub visited n k)

(* Print output based on yes/no full assigment *)
let () =
  if answer_node.(0) = ~-1 then
    print_endline
      (String.concat " "
         (List.map (String.make 1) (Array.to_list compiled_print_arr)))
  else
    print_endline
      (String.concat " "
         (List.map string_of_int (Array.to_list recruiters)))
