class_name Player
extends CharacterBody3D

const SPEED := 5.0

const EVENT_HELP := preload("res://dialogue/global/cmd_help_general.res")
const EVENT_INVENTORY := preload("res://dialogue/global/cmd_inventory.res")
const EVENT_RESPONSES := preload("res://dialogue/global/misc_responses.res")

var nav_target_pos := Vector3()
var has_nav_target := false

var walking := false

var current_camera_zone: CameraZone = null
var current_camera: Camera3D = null
var interacts_in_range: Array[Array] = [[], [], [], []]

@export var nav_height_offset := 0.5

@onready var nav_agent := $NavigationAgent as NavigationAgent3D
@onready var mouse_cursor := $MouseCursor as Decal

@onready var anim_tree := $AnimationTree as AnimationTree
@onready var anim_state_machine := anim_tree.tree_root as AnimationNodeStateMachine

func _ready() -> void:
	nav_agent.path_height_offset = nav_height_offset
	
	HUD.prompt_opened.connect(_on_hud_prompt_opened)
	HUD.prompt_closed.connect(_on_hud_prompt_closed)
	HUD.prompt_run.connect(_on_hud_prompt_run)
		
	mouse_cursor.visible = SettingsSubsystem.cursor


func _process(_delta: float) -> void:
	if PlayerStateSubsystem.can_player_move() and Input.is_action_just_pressed(&"prompt"):
		HUD.show_prompt()
		
	if current_camera != null:
		var mouse_pos := get_viewport().get_mouse_position()
		var origin := current_camera.project_ray_origin(mouse_pos)
		var destination := origin + current_camera.project_ray_normal(mouse_pos) * 10000
		var query := PhysicsRayQueryParameters3D.create(origin, destination, 4294967295 - 2048)
		var result := get_world_3d().direct_space_state.intersect_ray(query)
		var pos = result.get("position")
		if pos != null:
			mouse_cursor.global_position.x = pos.x
			mouse_cursor.global_position.z = pos.z
			mouse_cursor.global_position.y = pos.y + 0.1
	

func _physics_process(delta: float) -> void:
	if has_nav_target and not nav_target_pos.is_zero_approx():
		nav_agent.target_position = nav_target_pos
		var next_path_pos := nav_agent.get_next_path_position()
		var dir := global_position.direction_to(next_path_pos)
		velocity = dir * SPEED
		
		if nav_agent.is_navigation_finished():
			has_nav_target = false
			nav_target_pos = Vector3()
			
		var ROT_SPEED := 10.0
		var target_rotation := dir.signed_angle_to(Vector3.MODEL_FRONT, Vector3.DOWN)
		
		rotation.y = move_toward(rotation.y, target_rotation, delta * ROT_SPEED)
		mouse_cursor.global_rotation = Vector3.ZERO
		
		var tween := create_tween()
		tween.tween_property(anim_tree, ^"parameters/walk_blend/blend_amount", 1.0, 0.2)
	else:
		velocity = Vector3.ZERO
		var tween := create_tween()
		tween.tween_property(anim_tree, ^"parameters/walk_blend/blend_amount", 0.0, 0.2)
			
	move_and_slide()


func stop_immediately() -> void:
	has_nav_target = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"click") and PlayerStateSubsystem.can_player_move():
		var ray := mouse_screen_to_world(current_camera, 32768)
		if ray:
			nav_target_pos = ray["position"]
			has_nav_target = true

func mouse_screen_to_world(cam: Camera3D, mask: int) -> Dictionary:
	var mouse_position := cam.get_viewport().get_mouse_position()
	var ray_origin := cam.project_ray_origin(mouse_position)
	var ray_end := ray_origin + cam.project_ray_normal(mouse_position) * 1000
	
	var space_state := cam.get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.new()
	query.from = ray_origin
	query.to = ray_end
	query.collision_mask = mask
	var raycast := space_state.intersect_ray(query)
	return raycast

####################################################################################################

func coalesce_verbs(verb: String) -> String:
	match verb:
		"get", "pick up", "pickup":
			return "take"
		"attack", "hit":
			return "kill"
		"toss", "chuck":
			return "throw"
		_:
			return verb

####################################################################################################
	
func _on_interact_area_entered(area: Area3D, level: int) -> void:
	interacts_in_range[level].push_back(area.get_parent() as InteractionComponent)
	
func _on_interact_area_exited(area: Area3D, level: int) -> void:
	interacts_in_range[level].erase(area.get_parent() as InteractionComponent)
	
func _on_hud_prompt_run(prompt: String) -> void:
	var prompt_split := prompt.to_lower().split(" ")
	if prompt_split.has("the"):
		EventPlaybackSubsystem.play_event(EVENT_RESPONSES, self, current_camera_zone.default_text_box_size, "the")
		return
		
	if len(prompt_split) == 1:
		match prompt_split[0]:
			"help":
				EventPlaybackSubsystem.play_event(EVENT_HELP, self, current_camera_zone.default_text_box_size)
			"look":
				var look_string := ""
				var in_range := interacts_in_range[3].filter(func (obj: InteractionComponent): return not obj.hidden and obj.is_in_required_camera_zone(current_camera_zone))
				in_range.sort_custom(func (a: InteractionComponent, b: InteractionComponent): return a.aliases[0] < b.aliases[0])
				for i in range(len(in_range)):
					var obj: InteractionComponent = in_range[i]
					look_string += "an " if obj.aliases[0][0] in "aeiou" else "a "
					look_string += "[color=#ffff00]%s[/color]" % obj.aliases[0]
					if i < len(in_range) - 1:
						if len(in_range) > 2:
							look_string += ", "
							if i == len(in_range) - 2:
								look_string += "and "
						else:
							look_string += " and "
					
				EventPlaybackSubsystem.play_event(EVENT_RESPONSES, self, current_camera_zone.default_text_box_size, "look", "",
				{"look_string": look_string})
			"inventory":
				EventPlaybackSubsystem.play_event(EVENT_INVENTORY, self, Rect2i(20, 180, 280, 40), "", "", {"inventory_string": PlayerStateSubsystem.get_inventory_string()})
			_:
				EventPlaybackSubsystem.play_event(EVENT_RESPONSES, self, current_camera_zone.default_text_box_size, "error", "")
	else:
		var target: String
		var verb: String
		if len(prompt_split) == 4 and prompt_split[3] == "with":
			target = prompt_split[1]
			prompt_split.remove_at(1)
			verb = " ".join(prompt_split)
		else:
			target = prompt_split[-1]
			verb = " ".join(prompt_split.slice(0, len(prompt_split) - 1))

		var found := false
		for level in range(len(interacts_in_range)):
			for obj: InteractionComponent in interacts_in_range[level]:
				if obj.aliases.has(target) and obj.is_in_required_camera_zone(current_camera_zone):
					obj.interact_with(verb, level, current_camera_zone.default_text_box_size)
					found = true
					break
			
			if found:
				break
				
		if not found:
			EventPlaybackSubsystem.play_event(EVENT_RESPONSES, self, current_camera_zone.default_text_box_size, "no_object")
	

func _on_hud_prompt_opened() -> void:
	stop_immediately()
	
func _on_hud_prompt_closed() -> void:
	pass
