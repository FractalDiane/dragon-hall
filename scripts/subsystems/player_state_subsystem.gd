extends Node

var block_movement_sources := 0

func push_block_movement_source() -> void:
	block_movement_sources += 1
	
func pop_block_movement_source() -> void:
	block_movement_sources -= 1
	if block_movement_sources < 0:
		push_error("Imbalanced block movement sources stack")
		block_movement_sources = 0

func can_player_move() -> bool:
	return block_movement_sources == 0


func change_scene(target_scene: String, target_marker: String) -> void:
	const FADE_TIME := 0.8
	
	push_block_movement_source()
	HUD.fade_out(FADE_TIME)
	await get_tree().create_timer(FADE_TIME).timeout
	
	get_tree().change_scene_to_file(target_scene)
	await get_tree().create_timer(0.1).timeout
	
	var player := get_tree().current_scene.get_node(^"Player") as Player
	var marker := get_tree().current_scene.get_node(target_marker) as TransitionMarker
	player.global_position = marker.global_position
	if marker.camera_zone != null:
		marker.camera_zone.change_camera(player)
	
	HUD.fade_in(FADE_TIME)
	await get_tree().create_timer(FADE_TIME).timeout
	HUD.show_location_name((get_tree().current_scene as Room).room_name)
	pop_block_movement_source()
