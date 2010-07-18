open Mlsound

let play_harm n =
	let rates = S.of_succ (( *. ) 0.25) 0.5 in
	let up_freqs = S.of_succ (( *. ) 2.) 440. in
	let do_freqs = S.of_succ (( /. ) 2.) 440. in
	let freqs = S.altern2 (S.zip2 up_freqs rates) (S.zip2 do_freqs rates) in
	play (rierfou (S.firsts n freqs))

let _ =
	Arg.parse
		[ "-harm", Arg.Int play_harm, "Play the first n harmonics" ]
		(fun str -> invalid_arg str)
		"Make some noise.\n"
