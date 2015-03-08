" Vim plugin for running LOVE
" Last Change:	2015 March 07
" Maintainer:	Davis Claiborne <davisclaib@gmail.com>
" License:		This file is placed under public domain.

" Save and change compatibility options (not sure if I need it, but it's
" better to have it, I guess.
" s:<var> makes the variable local to the script
let s:save_cpo = &cpo
set cpo&vim

" Keep the entire script from being loaded if it's already active
if exists( 'g:loaded_love-launch' )
	finish
endif
let g:loaded_lovelaunch = 1

" Set the default path for current LOVE version
if !exists( 'g:lovelaunch_path' ) 
	g:lovelaunch_path = 'C:\Prorgam Files\LOVE\love.exe'
endif

map <M-l> <Plug>lovelaunchRun
noremap <script> <plug>lovelaunchRun <SID>Run
noremap <SID>Run :call <SID>Run()<CR>

function s:Run()
	let exist = findfile( 'main.lua', '.;' )
	if filereadable( exist ) " You should be able to read your main.lua file...
		let s:reps = 0
		while !filereadable( expand( '%:p' . repeat( ':h', s:reps ) ) . '/main.lua' )
			let s:reps += 1
		endwhile
		let s:location = expand( expand( '%:p' . repeat( ':h', s:reps ) ) ) " To actually execute, use the folder.
		execute 'silent ! start ""' shellescape( g:lovelaunch_path ) shellescape( s:location )
	else " Not in a LOVE directory
		echo 'love-launch error: no file "main.lua" in current or above directories.'
	endif
endfunction

" Reset compatibility options
let &cpo = s:save_cpo
