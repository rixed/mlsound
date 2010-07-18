open Format
module S = Stream_impl.Stream_raw
open S

external write_float : Unix.file_descr -> float -> unit
	= "help_write_float"

let version = "The buggy one !"
let rate = 11000.

let play s =
	let play_cmd = sprintf "play -q -t raw -r %d -f -8 -" (int_of_float rate) in
	let chn = Unix.open_process_out play_cmd in
	let fd = Unix.descr_of_out_channel chn in
	iter s (write_float fd) ;
	ignore (Unix.close_process_out chn)

let show s =
	let show_cmd = "gnuplot -persist" in
	let chn = Unix.open_process_out show_cmd in
	let fmt = formatter_of_out_channel chn in
	let dt = 1. /. rate in
	let times = S.of_succ ((+.) dt) 0. in
	fprintf fmt "plot \"-\" with lines@." ;
	S.iter (S.zip2 times s) (fun (x, y) -> fprintf fmt "%f %f@." x y) ;
	fprintf fmt "e@.@?" ; (* flush *)
	ignore (Unix.close_process_out chn)

let pi = 4. *. atan 1.

let sinus freq =
	let i = 2. *. pi *. freq /. rate in
	let range = S.of_succ ((+.) i) 0. in
	S.map range sin

let ecrete s thresold =
	S.map s (fun f ->
		if f > thresold then thresold
		else if f < -.thresold then -.thresold
		else f)

let rierfou freqs =
	let sins = S.map freqs (fun (f, r) -> map (sinus f) (( *. ) r)) in
	S.map (S.zip sins) (fun samples -> S.fold samples 0. (+.))
