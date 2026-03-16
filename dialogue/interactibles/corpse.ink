{ interact_verb:
- "look":
	{ range:
	- 0:
		Looks like the death was very recent.
		A small gold-colored key is on the ground next to their pocket.
	- else:
		Too far for a close look.
	}
- "pick up":
	-> range_check ->
	You decided it was best not to.
- else:
	Cannot do.
}

INCLUDE dialogue/funcs.ink
