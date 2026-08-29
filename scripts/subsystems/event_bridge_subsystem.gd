extends Node

func push_library_button(button: String) -> void:
	(get_tree().current_scene.get_node("PuzzleHandler") as LibraryPuzzleHandler).push_button(button)

func is_library_puzzle_solved() -> bool:
	return (get_tree().current_scene.get_node("PuzzleHandler") as LibraryPuzzleHandler).solved
