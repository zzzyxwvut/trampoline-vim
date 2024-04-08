let s:cpoptions = &cpoptions
set cpoptions-=C

source ../plugin/trampoline.vim


" Factorial numbers.

let s:state = {'n': 0, 'p': 0}

function! s:state.F() abort
	let s:state.p = s:state.p * s:state.n
	let s:state.n -= 1
	return s:state.R()
endfunction

function! s:state.R() abort
	return s:state.n == 0 ? Land(s:state.p) : Bounce(s:state.F)
endfunction

function! Fact1(x) abort
	if a:x < 0
		throw 'Negative number'
	endif

	let s:state.n = a:x
	let s:state.p = 1
	return Mount(s:state.R())
endfunction

function! Fact2(x) abort
	return a:x < 2 ? 1 : (Fact2(a:x - 1) * a:x)
endfunction

try
	set maxfuncdepth=7
	echo Fact1(0)
	echo Fact1(12)

	set maxfuncdepth=12
	echo Fact2(0)
	echo Fact2(12)
finally
	set maxfuncdepth&
endtry




" Fibonacci numbers.

let s:state = {'n': 0, 'a1': 1, 'a2': 0}

function! s:state.F() abort
	let sum = s:state.a1 + s:state.a2
	let s:state.a1 = s:state.a2
	let s:state.a2 = sum
	let s:state.n -= 1
	return s:state.R()
endfunction

function! s:state.R() abort
	return s:state.n == 0
		\ ? Land(0)
		\ : s:state.n == 1
			\ ? Land(s:state.a1 + s:state.a2)
			\ : Bounce(s:state.F)
endfunction

function! Fib1(x) abort
	if a:x < 0
		throw 'Negative number'
	endif

	let s:state.n = a:x
	let s:state.a1 = 1
	let s:state.a2 = 0
	return Mount(s:state.R())
endfunction

function! Fib2(x) abort
	if a:x < 0
		throw 'Negative number'
	endif

	" Iterate a fib and recurse a fib.
	return a:x == 0
		\ ? 0
		\ : a:x == 1
			\ ? 1
			\ : (Fib1(a:x - 1) + Fib2(a:x - 2))
endfunction

function! Fib3(x) abort
	let a1 = 0
	let a2 = 1

	for dummy in range(a:x)
		let sum = a1 + a2
		let a1 = a2
		let a2 = sum
	endfor

	return a1
endfunction

try
	set maxfuncdepth=7
	echo Fib1(0)
	echo Fib1(46)

	set maxfuncdepth=29
	echo Fib2(0)
	echo Fib2(46)

	set maxfuncdepth=1
	echo Fib3(0)
	echo Fib3(46)
finally
	set maxfuncdepth&
endtry


let &cpoptions = s:cpoptions
unlet s:cpoptions

" vim:fdm=syntax:sw=8:ts=8:noet:nolist:nosta:
