" Description:	Express control transfers of tail-recursive function calls in
"		terms of iteration
" Porter:	Aliaksei Budavei (0x000c70 AT gmail DOT com)
" Repository:	https://github.com/zzzyxwvut/trampoline-vim.git [vim/7000000/master]
" Version:	1.0
" Last Change:	2024-Apr-08
" Copyleft ())

let s:dispatch = {'bt': {}, 'lt': {}}


function! s:dispatch.bt.Bounceable() abort
	return 1
endfunction

function! s:dispatch.bt.Bounce() abort
	return s:dispatch.bt.Routine()
endfunction

function! s:dispatch.bt.Land() abort
	let trampoline = s:dispatch.bt

	while (trampoline.Bounceable())
		let trampoline = trampoline.Bounce()
	endwhile

	return trampoline.Land()
endfunction


function! s:dispatch.lt.Bounceable() abort
	return 0
endfunction

function! s:dispatch.lt.Bounce() abort
	throw 'Unsupported operation'
endfunction

function! s:dispatch.lt.Land() abort
	return s:dispatch.lt.result
endfunction


function! Mount(trampoline) abort
	return a:trampoline.Land()
endfunction

function! Bounce(Routine) abort
	let s:dispatch.bt.Routine = a:Routine
	return s:dispatch.bt
endfunction

function! Land(result) abort
	let s:dispatch.lt.result = a:result
	return s:dispatch.lt
endfunction

" vim:fdm=syntax:sw=8:ts=8:noet:nolist:nosta:
