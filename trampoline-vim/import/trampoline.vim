vim9script

# Description:	Express control transfers of tail-recursive function calls in
#		terms of iteration
# Porter:	Aliaksei Budavei (0x000c70 AT gmail DOT com)
# Repository:	https://github.com/zzzyxwvut/trampoline-vim.git [vim/9001556/master]
# Version:	3.0
# Last Change:	2024-Apr-08
# Copyleft ())

export def Mount(trampoline: dict<any>): any
	return trampoline.Land_()
enddef

export def Bounce(Routine: func(): dict<any>): dict<any>
	def Bounceable_(): bool
		return true
	enddef

	def Bounce_(R: func(): dict<any>): dict<any>
		return R()
	enddef

	def Land_(R: func(): dict<any>): any
		var trampoline: dict<any> = R()

		while (trampoline.Bounceable_())
			trampoline = trampoline.Bounce_()
		endwhile

		return trampoline.Land_()
	enddef

	return {
		Land_: function(Land_, [Routine]),
		Bounce_: function(Bounce_, [Routine]),
		Bounceable_: function(Bounceable_),
	}
enddef

export def Land(result: any): dict<any>
	def Bounceable_(): bool
		return false
	enddef

	def Bounce_(_: dict<any>): dict<any>
		throw 'Unsupported operation'
	enddef

	def Land_(r: any): any
		return r
	enddef

	return {
		Land_: function(Land_, [result]),
		Bounce_: function(Bounce_, [{}]),
		Bounceable_: function(Bounceable_),
	}
enddef

# vim:fdm=syntax:sw=8:ts=8:noet:nolist:nosta:
