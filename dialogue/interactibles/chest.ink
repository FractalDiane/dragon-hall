{ interact_verb:
- "look":
	It's closed.
- "open":
	-> range_check ->
	It's locked.
- "pick up":
	-> range_check ->
	Too heavy.
- "kick":
	-> range_check ->
	Ouch!
	No effect.
- else:
	Cannot do.
}

INCLUDE dialogue/funcs.ink
