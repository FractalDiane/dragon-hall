class_name CameraZone
extends Area3D

@export var camera: Camera3D = null
@export var default_text_box_size := Rect2i(20, 180, 280, 40)

func _on_body_entered(body: Node3D) -> void:
	if PlayerStateSubsystem.can_player_move():
		change_camera(body as Player)

func change_camera(player: Player) -> void:
	camera.current = true
	player.current_camera_zone = self
	player.current_camera = camera
