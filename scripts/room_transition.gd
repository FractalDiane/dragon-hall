class_name RoomTransition
extends Area3D

@export_file("*.tscn") var target_scene := ""
@export var target_marker := ""

func _on_body_entered(_body: Node3D) -> void:
	PlayerStateSubsystem.change_scene(target_scene, target_marker)
