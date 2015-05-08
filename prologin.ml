(*
** This file has been generated, if you wish to
** modify it in a permanent way, please refer
** to the script file : gen/generator_caml.rb
*)

open Api;;

let min_list l ( < ) =
  match l with
    [] -> failwith "empty list"
  | h :: t ->
    List.fold_left (fun u v -> if u < v then u else v) h t
;;

let min_list_key l key =
  min_list l (fun x y -> key x < key y)
;;

let move_towards (x, y) =
  let d = points_deplacement () in
  let (xx, yy) = position_agent (moi ()) in
  let adx = min (abs (x - xx)) d in
  let ady = min (abs (y - yy)) (d - adx) in
  let dx = if xx < x then adx else -adx in
  let dy = if yy < y then ady else -ady in
  ignore (deplacer (xx + dx, yy + dy))
;;

let err f x =
  match (f x) with
    Ok -> ()
  | _ -> failwith ""
;;

let neutraliserf = err neutraliser;;
let capturerf = err capturer;;
let lierf = err lier;;


let rec prog_con_step () =
  let portails_pas_a_moi =
    (List.filter (fun pos -> portail_joueur pos <> moi ())
       (Array.to_list (liste_portails ()))) in
  if portails_pas_a_moi = [] then () else begin
    let closest = min_list_key portails_pas_a_moi
      (distance (position_agent (moi ()))) in
    move_towards closest;
    let pp = portail_joueur closest in
    if (pp <> adversaire () && pp <> (-1)) then begin
      if (utiliser_turbo ()) = Ok then prog_con_step ()
    end else begin
      try
        if (pp = adversaire ()) then begin neutraliserf () end;
        capturerf ();
        Array.iter (fun p ->
          match lier p with
            Pa_insuffisants -> failwith ""
          | _ -> ()) (liste_portails ());
        prog_con_step ()
      with
        _ -> ()
    end
  end
;;

(*
let prog_con () =
  
;;
*)














(*
** Fonction appelée au début de la partie.
*)
let partie_init () =  (* Pose ton code ici *)
  flush stderr; flush stdout;; (* Pour que vos sorties s'affichent *)

(*
** Fonction appelée à chaque tour.
*)
let jouer_tour () =  (* Pose ton code ici *)
  print_int 0;
  prog_con_step ();
  flush stderr; flush stdout;; (* Pour que vos sorties s'affichent *)

(*
** Fonction appelée à la fin de la partie.
*)
let partie_fin () =  (* Pose ton code ici *)
  flush stderr; flush stdout;; (* Pour que vos sorties s'affichent *)

(* /!\ Ne touche pas a ce qui suit /!\ *)
Callback.register "ml_partie_init" partie_init;;Callback.register "ml_jouer_tour" jouer_tour;;Callback.register "ml_partie_fin" partie_fin;;
