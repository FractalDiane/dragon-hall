class_name LibraryPuzzleHandler
extends Node

const SOLUTION := "YGRBGR"
var guess := String()
var solved := false

func push_button(button: String) -> void:
	guess += button
	print(guess)
	if SOLUTION.substr(0, len(guess)) == guess:
		if len(guess) == len(SOLUTION):
			solved = true
	else:
		guess = ""
