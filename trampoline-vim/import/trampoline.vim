vim9script

# Description:	Express control transfers of tail-recursive function calls in
#		terms of iteration
# Porter:	Aliaksei Budavei (0x000c70 AT gmail DOT com)
# Repository:	https://github.com/zzzyxwvut/trampoline-vim.git [vim/9010160/master]
# Version:	4.0
# Last Change:	2024-Apr-08
# Copyleft ())

export interface Trampoline
	def Bounceable(): bool
	def Bounce(): Trampoline
	def Land(): any
endinterface

class BT implements Trampoline
	const Routine: func(): Trampoline

	def new(this.Routine)
	enddef

	def Bounceable(): bool
		return true
	enddef

	def Bounce(): Trampoline
		return this.Routine()
	enddef

	def Land(): any
		var trampoline: Trampoline = this

		while (trampoline.Bounceable())
			trampoline = trampoline.Bounce()
		endwhile

		return trampoline.Land()
	enddef
endclass

class LT implements Trampoline
	const result: any

	def new(this.result)
	enddef

	def Bounceable(): bool
		return false
	enddef

	def Bounce(): Trampoline
		throw 'Unsupported operation'
	enddef

	def Land(): any
		return this.result
	enddef
endclass

export abstract class Trampolinist
	static def Mount(trampoline: Trampoline): any
		return trampoline.Land()
	enddef

	static def Bounce(Routine: func(): Trampoline): Trampoline
		return BT.new(Routine)
	enddef

	static def Land(result: any): Trampoline
		return LT.new(result)
	enddef
endclass

# vim:fdm=syntax:sw=8:ts=8:noet:nolist:nosta:
