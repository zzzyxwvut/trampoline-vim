vim9script

if strridx(&runtimepath, ',../') < 0
	lcd %:p:h
	&runtimepath ..= ',../'
endif

import 'trampoline.vim' as lib


# Factorial numbers.

def Fact1(x: number): number
	if x < 0
		throw 'Negative number'
	endif

	def F(G: func(number, number): lib.Trampoline): func(number, number):
							\ func(): lib.Trampoline
		return ((H: func(number, number): lib.Trampoline) =>
					(n: number, p: number) =>
					() =>
			H((n - 1), (p * n)))(G)
	enddef

	def R(number: number, product: number): lib.Trampoline
		return number == 0
			? lib.Trampolinist.Land(product)
			: lib.Trampolinist.Bounce(F(function(R))(number, product))
	enddef

	return lib.Trampolinist.Mount(R(x, 1))
enddef

def Fact2(x: number): number
	return x < 2 ? 1 : (Fact2(x - 1) * x)
enddef

try
	set maxfuncdepth=9
	echo Fact1(0)
	echo Fact1(20)

	set maxfuncdepth=21
	echo Fact2(0)
	echo Fact2(20)
finally
	set maxfuncdepth&
endtry




# Fibonacci numbers.

def Fib1(x: number): number
	if x < 0
		throw 'Negative number'
	endif

	def F(G: func(number, number, number): lib.Trampoline):
						\ func(number, number, number):
						\ func(): lib.Trampoline
		return ((H: func(number, number, number): lib.Trampoline) =>
					(a1: number, a2: number, n: number) =>
					() =>
			H(a2, (a1 + a2), (n - 1)))(G)
	enddef

	def R(a1: number, a2: number, number: number): lib.Trampoline
		return number == 0
			? lib.Trampolinist.Land(0)
			: number == 1
				? lib.Trampolinist.Land(a1 + a2)
				: lib.Trampolinist.Bounce(F(function(R))(a1, a2, number))
	enddef

	return lib.Trampolinist.Mount(R(1, 0, x))
enddef

def Fib2(x: number): number
	if x < 0
		throw 'Negative number'
	endif

	# Iterate a fib and recurse a fib.
	return x == 0
		? 0
		: x == 1
			? 1
			: (Fib1(x - 1) + Fib2(x - 2))
enddef

def Fib3(x: number): number
	var a1: number = 0
	var a2: number = 1

	for _ in range(x)
		const sum: number = a1 + a2
		a1 = a2
		a2 = sum
	endfor

	return a1
enddef

try
	set maxfuncdepth=9
	echo Fib1(0)
	echo Fib1(92)

	set maxfuncdepth=54
	echo Fib2(0)
	echo Fib2(92)

	set maxfuncdepth=2
	echo Fib3(0)
	echo Fib3(92)
finally
	set maxfuncdepth&
endtry

# vim:fdm=syntax:sw=8:ts=8:noet:nolist:nosta:
