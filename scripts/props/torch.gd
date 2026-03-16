extends Node3D

func _ready() -> void:
	var player := $AudioStreamPlayer3D as AudioStreamPlayer3D
	player.seek(randf_range(0.0, player.stream.get_length()))
