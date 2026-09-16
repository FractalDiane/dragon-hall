extends Node

func push_library_button(button: String) -> void:
	(get_tree().current_scene.get_node("PuzzleHandler") as LibraryPuzzleHandler).push_button(button)

func flip_lavaworks_lever() -> void:
	(get_tree().current_scene.get_node("BridgesHandler") as LavaworksBridgesHandler).flip_lever()
