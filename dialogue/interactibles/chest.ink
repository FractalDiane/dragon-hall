{ INTERACT_VERB:
- "look":
	It's closed.
- "open":
	-> range_check ->
	It's locked.
- "take":
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
