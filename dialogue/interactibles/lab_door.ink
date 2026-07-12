{ INTERACT_VERB:
- "look":
	Amazingly, it's a door.
- "open":
	{ is_human():
		You think about it for a few moments.
		You realize that you can, in fact, open the door.
	  - else:
		You appear to no longer be able to reach the door knob.
		Even if you could, it would be difficult to open with dragon paws.
		You appear to be stuck in this room.
		Game over.
	}
- else:
	Cannot do.
}
