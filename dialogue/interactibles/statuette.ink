{ INTERACT_VERB:
- "look":
	A small idol shaped like a dragon.
- "take":
	~ add_item("idol")
	~ pick_up_item(CALLER_PATH)
	Taken.
- else:
	Cannot do.
}

INCLUDE dialogue/funcs.ink
