class_name Player
extends CharacterBody3D

const SPEED := 5.0

const EVENT_INVENTORY := preload("res://dialogue/global/cmd_inventory.res")
const EVENT_RESPONSES := preload("res://dialogue/global/misc_responses.res")

@export var camera: Camera3D = null

var current_camera_zone: CameraZone = null
var interacts_in_range: Array[Array] = [[], [], [], []]

@onready var nav_agent := $NavigationAgent as NavigationAgent3D

func _ready() -> void:
	nav_agent.path_desired_distance = 0.1
	nav_agent.target_desired_distance = 0.1
	
	HUD.prompt_opened.connect(_on_hud_prompt_opened)
	HUD.prompt_closed.connect(_on_hud_prompt_closed)
	HUD.prompt_run.connect(_on_hud_prompt_run)
	
	var floors := get_tree().get_nodes_in_group(&"floor")
	for node: StaticBody3D in floors:
		node.input_event.connect(_on_floor_input_event)
	

func _process(_delta: float) -> void:
	if PlayerStateSubsystem.can_player_move() and Input.is_action_just_pressed(&"prompt"):
		HUD.show_prompt()
	

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
		
	var current_pos := global_position
	var next_path_pos := nav_agent.get_next_path_position()
	velocity = (current_pos.direction_to(next_path_pos) * SPEED) if PlayerStateSubsystem.can_player_move() else Vector3.ZERO
	move_and_slide()


func stop_immediately() -> void:
	nav_agent.target_position.x = global_position.x
	nav_agent.target_position.z = global_position.z


func _on_floor_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if PlayerStateSubsystem.can_player_move() and event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		nav_agent.target_position.x = event_position.x
		nav_agent.target_position.z = event_position.z

####################################################################################################

func coalesce_verbs(verb: String) -> String:
	match verb:
		"get", "pick up", "pickup":
			return "take"
		"attack", "hit":
			return "kill"
		"toss":
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
			"look":
				var look_string := ""
				var in_range := interacts_in_range[3].filter(func (obj: InteractionComponent): return not obj.hidden)
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
				if obj.aliases.has(target):
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
