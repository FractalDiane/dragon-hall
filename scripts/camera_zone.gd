class_name CameraZone
extends Area3D

@export var camera: Camera3D = null


func _on_body_entered(_body: Node3D) -> void:
	camera.current = true
