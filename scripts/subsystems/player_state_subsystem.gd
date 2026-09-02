extends Node

enum {
	FORM_HUMAN,
	FORM_DRAGON,
	FORM_DRAGONSMALL,
}

const SAVE_FILE := "user://save.dat"
const GAME_OVER_UI := preload("res://prefabs/ui/game_over.tscn")

var block_movement_sources := 0
var inventory: Dictionary[StringName, int] = {}
var items_picked_up: Dictionary[NodePath, bool] = {}

var flags := {}

var current_form := FORM_HUMAN

func _ready() -> void:
	var current_room := get_tree().current_scene as Room
	if current_room != null:
		HUD.show_location_name(current_room.room_name)


func push_block_movement_source() -> void:
	block_movement_sources += 1
	
func pop_block_movement_source() -> void:
	block_movement_sources -= 1
	if block_movement_sources < 0:
		push_error("Imbalanced block movement sources stack")
		block_movement_sources = 0

func can_player_move() -> bool:
	return block_movement_sources == 0
	
	
func give_flag(flag: StringName) -> void:
	flags[flag] = true
	
	
func take_flag(flag: StringName) -> void:
	flags.erase(flag)
	
	
func has_flag(flag: StringName) -> bool:
	return flags.has(flag)
	

func flag_count(flag: StringName) -> int:
	return flags.get(flag, 0)
	
	
func get_current_form() -> int:
	return current_form


func has_item(item: StringName) -> bool:
	return inventory.has(item)
	
	
func has_item_count(item: StringName, count: int) -> bool:
	return inventory.get(item, 0) >= count
	
	
func add_item(item: StringName) -> void:
	if not inventory.has(item):
		inventory[item] = 0
	
	inventory[item] += 1
	
	
func get_inventory_string() -> String:
	if inventory.is_empty():
		return ""
		
	var result := ""
	for item in inventory:
		var count := inventory[item]
		result += "[color=#ffff00]%s[/color]%s, " % [item, ("x%d" % count) if count > 1 else ""]
		
	return result.substr(0, len(result) - 2)
	
	
func pick_up_item(path: NodePath) -> void:
	items_picked_up[path] = true
	get_tree().current_scene.get_node(path).queue_free()
	
	
func is_item_picked_up(path: NodePath) -> bool:
	return items_picked_up.has(path)


func change_scene(target_scene: String, target_marker: NodePath) -> void:
	const FADE_TIME := 0.8
	
	push_block_movement_source()
	HUD.fade_out(FADE_TIME)
	await get_tree().create_timer(FADE_TIME).timeout
	
	get_tree().change_scene_to_file(target_scene)
	await get_tree().create_timer(0.2).timeout
	
	var player := get_tree().current_scene.get_node(^"Player") as Player
	var marker := get_tree().current_scene.get_node(target_marker) as TransitionMarker
	player.global_position = marker.global_position
	if marker.camera_zone != null:
		marker.camera_zone.change_camera(player)
	
	save_game(target_marker)
	
	HUD.fade_in(FADE_TIME)
	await get_tree().create_timer(FADE_TIME).timeout
	HUD.show_location_name((get_tree().current_scene as Room).room_name)
	pop_block_movement_source()
	
	
func save_game(marker: NodePath) -> void:
	var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	
	file.store_pascal_string(get_tree().current_scene.get_path().get_name(1))
	file.store_var(marker)
	file.store_var(inventory, false)
	file.store_var(items_picked_up, false)
	
	file.close()

func load_game() -> void:
	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	
	var current_scene := file.get_pascal_string()
	var marker: NodePath = file.get_var(false)
	inventory = file.get_var(false)
	items_picked_up = file.get_var(false)
	
	change_scene("res://scenes/game_maps/%s.tscn" % current_scene.to_lower(), marker)
	
	file.close()

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_FILE)
	
	
func game_over() -> void:
	push_block_movement_source()
	var ui := GAME_OVER_UI.instantiate() as Control
	get_tree().get_root().add_child(ui)
	
