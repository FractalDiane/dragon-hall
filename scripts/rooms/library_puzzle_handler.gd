class_name LibraryPuzzleHandler
extends Node

@export var anim_player: AnimationPlayer
@export var bookshelf_collision: CollisionShape3D

const PUZZLE_FLAG := &"library_puzzle_solve"

const SOLUTION := "YGRBGR"
var guess := String()
var solved := false

func _ready() -> void:
	if PlayerStateSubsystem.has_flag(PUZZLE_FLAG):
		solved = true
		lower_bookcase(true)

func push_button(button: String) -> void:
	if not solved:
		guess += button
		print(guess)
		if SOLUTION.substr(0, len(guess)) == guess:
			if len(guess) == len(SOLUTION):
				lower_bookcase(false)
				PlayerStateSubsystem.give_flag(PUZZLE_FLAG)
				solved = true
		else:
			guess = ""

func lower_bookcase(instant: bool) -> void:
	if not instant:
		PlayerStateSubsystem.push_block_movement_source()
		anim_player.play(&"remove_bookcase")
		await anim_player.animation_finished
		bookshelf_collision.disabled = true
		PlayerStateSubsystem.pop_block_movement_source()
	else:
		anim_player.play(&"remove_bookcase", -1, 100.0)
		bookshelf_collision.disabled = true
