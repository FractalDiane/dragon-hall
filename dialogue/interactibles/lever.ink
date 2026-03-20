-> main
=== main ===
{ INTERACT_VERB:
- "look":
	The lever is currently set to OFF.
- "pull":
	-> range_check ->
	-> pull
- "push":
	-> range_check ->
	-> pull
- "flip":
	-> range_check ->
	-> pull
- "activate":
	-> range_check ->
	-> pull
- "throw rock at":
	DIRECT HIT!
- "throw tissue at":
	It blew back at your face.
- "throw fishpole at":
	-> dont_throw_that
- "throw idol at":
	-> dont_throw_that
- "throw potion at":
	-> dont_throw_that
- "throw fish at":
	-> dont_throw_that
- "throw sword at":
	-> dont_throw_that
- "throw coin at":
	-> dont_throw_that
- else:
	Cannot do.
}

=== dont_throw_that ===
You decided it would be highly, HIGHLY counterproductive to throw that.
-> END

=== pull ===

INCLUDE dialogue/funcs.ink
