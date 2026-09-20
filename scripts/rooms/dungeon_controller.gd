class_name DungeonController
extends Node

const flag := &"dungeon_dark"

func _enter_tree() -> void:
	PlayerStateSubsystem.give_flag(flag)
	
func _exit_tree() -> void:
	PlayerStateSubsystem.take_flag(flag)
