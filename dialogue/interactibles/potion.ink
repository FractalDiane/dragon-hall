{ INTERACT_VERB:
- "look":
	{ INTERACT_ITEM:
	- "redpotion":
		A vivid-colored potion.
	- "greenpotion":
		A pretty-colored potion.
	- "bluepotion":
		A lovely-colored potion.
	- "yellowpotion":
		A pale-colored potion.
	- "purplepotion":
		An odd-colored potion.
	}
	
	It's labeled "Potion of Draconification."
- "take":
	-> dragon_check ->
	It's attached to a security chain.
	You can pick it up, but you can't take it away from the table.
- "drink":
	-> dragon_check ->
	-> range_check ->
	{ INTERACT_ITEM:
	- "redpotion":
		Nothing happened.
		There's a note on the bottom of the bottle.
		"This one didn't work."
	- "greenpotion":
		Nothing happened.
		There's a note on the bottom of the bottle.
		"This one also didn't work."
	- "bluepotion":
		A lovely-colored potion.
	- "yellowpotion":
		Nothing happened.
		There's a note on the bottom of the bottle.
		"0/3 success rate so far. Not good."
	- "purplepotion":
		Nothing happened.
		There's a note on the bottom of the bottle.
		"We are no closer to getting it working."
	}
- "pour greenpotion into":
	-> dragon_check ->
	You thought of the resulting color and gasped in horror.
	You decided not to.
- "pour bluepotion into":
	-> dragon_check ->
	You thought of the resulting color and realized it was not meant for human eyes.
	You decided not to.
- "pour purplepotion into":
	-> dragon_check ->
	You thought of the resulting color and vowed never to imagine this color again.
	You decided not to.
- "pour redpotion into":
	-> dragon_check ->
	{ INTERACT_ITEM == "yellowpotion":
		The yellowpotion changed color!
		It is now an [color=\#ffff00]orangepotion.[/color]
	- else:
		You thought of the resulting color and grimaced.
		You decided not to.
	}
- "pour yellowpotion into":
	-> dragon_check ->
	{ INTERACT_ITEM == "redpotion":
		The redpotion changed color!
		It is now an [color=\#ffff00]orangepotion.[/color]
	- else:
		You thought of the resulting color and immediately stopped thinking because you got scared.
		You decided not to.
	}
- else:
	Cannot do.
}

=== dragon_check ===
{is_dragon_small(): Well, you can't exactly reach it anymore, can you? -> END}
->->

INCLUDE dialogue/funcs.ink
