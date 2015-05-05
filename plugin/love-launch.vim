" Vim plugin for running LOVE
" Last Change:	2015 March 07
" Maintainer:	Davis Claiborne <davisclaib@gmail.com>
" License:		This file is placed under public domain.

let s:save_cpo = &cpo
set cpo&vim

if exists( 'g:loaded_lovelaunch' )
	finish
endif
let g:loaded_lovelaunch = 1

" Set the default path for current LOVE version
if !exists( 'g:lovelaunch_path' ) 
	let g:lovelaunch_path = 'C:\Prorgam Files\LOVE\love.exe' " File path for location of love.exe
endif
if !exists( 'g:lovelaunch_conf' )
	let g:lovelaunch_conf = 0 " Default to NOT need a conf.lua
endif
if !exists( 'g:lovelaunch_conf_loops' )
	let g:lovelaunch_conf_loops = 2 " Number of times to accept seeing conf.lua and main.lua paired together. Can be ignored.
endif
if !exists( 'g:lovelaunch_max_loops' )
	let g:lovelaunch_max_loops = 10 " Max number of loops before failing.
endif

" Mapping
if !hasmapto( '<Plug>lovelaunchRun' )
	map <silent> <M-r> <Plug>lovelaunchRun
endif
noremap <script> <Plug>lovelaunchRun <SID>Run
noremap <SID>Run :call <SID>Run()<CR>

" Functions
function s:Fail()
	echo 'love-launch error: no file "main.lua" in current or above directories.'
endfunction

function s:Loop()
	while !( filereadable( expand( '%:p' . repeat( ':h', s:reps ) ) . '/main.lua' ) )
		if s:max_loops <= 0 
			return 0
		else
			let s:max_loops -= 1
			let s:reps += 1
		endif
	endwhile
	return 1
endfunction

function s:Check()
	let s:location = expand( expand( '%:p' . repeat( ':h', s:reps ) ) ) " To actually execute, use the folder.
	if ( ( g:lovelaunch_conf < 1 ) || ( g:lovelaunch_conf > 0 && filereadable( expand( '%:p' . repeat( ':h', s:reps ) ) . '/conf.lua' ) ) )
		execute 'silent ! start ""' shellescape( g:lovelaunch_path ) shellescape( s:location )
	elseif g:lovelaunch_conf > 0
		let s:reps += 1
		let s:conf_loops -= 1

		if s:conf_loops > 0
			let s:proceed = s:Loop()
			if s:proceed
				call s:Check()
			else
				call s:Fail()
			endif
		else
			call s:Fail()
		endif
	endif
endfunction

function s:Run()
	let exist = findfile( 'main.lua', '.;' )

	if filereadable( exist ) " You should be able to read your main.lua file...
		let s:reps = 0
		let s:conf_loops = g:lovelaunch_conf_loops
		let s:max_loops = g:lovelaunch_max_loops

		call s:Loop()
		call s:Check()
	else " Not in a LOVE directory
		call s:Fail()
	endif
endfunction

" Reset compatibility options
let &cpo = s:save_cpo
