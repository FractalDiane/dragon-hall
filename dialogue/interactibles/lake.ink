-> main

=== main ===
{ INTERACT_VERB:
- "look":
	The water is a deep blue.
	A fish frolicks happily.
- "jump into":
	-> try_jumping
- "leap into":
	-> try_jumping
- "dive into":
	-> try_jumping
- "jump in":
	-> try_jumping
- "leap in":
	-> try_jumping
- "dive in":
	-> try_jumping
- else:
	Cannot do.
}

=== try_jumping ===
Oops! The water is frigid.
Lethally frigid, in fact!
-> END

INCLUDE dialogue/funcs.ink
