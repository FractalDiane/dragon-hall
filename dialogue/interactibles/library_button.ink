{ INTERACT_VERB:
- "look":
	A button on the wall.
	If you slam your entire body into it, you might be able to press it.
- "push":
	{ INTERACT_ITEM:
	- "redbutton":
		You pressed the red button.
		~ push_library_button("R")
	- "bluebutton":
		You pressed the blue button.
		~ push_library_button("B")
	- "greenbutton":
		You pressed the green button.
		~ push_library_button("G")
	- "yellowbutton":
		You pressed the yellow button.
		~ push_library_button("Y")
	}
- else:
	Cannot do.
}

INCLUDE dialogue/funcs.ink
