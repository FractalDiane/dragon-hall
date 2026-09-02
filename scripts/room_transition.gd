class_name RoomTransition
extends Area3D

@export_file("*.tscn") var target_scene := ""
@export var target_marker := ""

@export var can_use_as_dragon := true

func _on_body_entered(body: Node3D) -> void:
	var current_form := PlayerStateSubsystem.get_current_form()
	if current_form != PlayerStateSubsystem.FORM_DRAGONSMALL and (can_use_as_dragon or current_form == PlayerStateSubsystem.FORM_HUMAN):
		(body as Player).stop_immediately()
		PlayerStateSubsystem.change_scene(target_scene, target_marker)
