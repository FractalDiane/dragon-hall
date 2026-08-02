class_name InteractionComponent
extends Node3D

signal interaction_started()
signal interaction_finished()

@export var aliases: Array[String] = []
@export var hidden := false
@export var can_pick_up := false
@export var interact_event: QuillaStoryCompiled = null
@export var proximity_levels_required: Dictionary[String, int] = {"look": 3}
@export var text_box_position := Rect2i()
@export var set_variables: Dictionary[StringName, Variant] = {}

func _ready() -> void:
	if OS.has_feature("editor") and interact_event == null:
		push_error("%s has no interact event set" % get_parent().get_path())
		
	if can_pick_up and PlayerStateSubsystem.is_item_picked_up(get_parent().get_path()):
		get_parent().queue_free()

func interact_with(action: String, proximity_level: int, box_position_: Rect2i, item := "") -> void:
	var event_player: EventPlayer
	var box_position := text_box_position if text_box_position != Rect2i() else box_position_
	if action == "help":
		var help_string := String()
		var acts := get_all_actions()
		for act in acts:
			help_string += "[color=#ffff00]%s[/color], " % act
		
		help_string = help_string.substr(0, len(help_string) - 2)
		event_player = EventPlaybackSubsystem.play_event(preload("res://dialogue/global/cmd_help.res"), self, box_position, "", "", {"HELP_STRING": help_string})
	else:
		var level_required := proximity_levels_required[action] if proximity_levels_required.has(action) else 0
		event_player = EventPlaybackSubsystem.play_event(interact_event, self, box_position, action, aliases[0] if item.is_empty() else item, set_variables.merged({"range": proximity_level, "range_required": level_required}))
		
	event_player.event_finished.connect(_on_interact_event_finished)
	interaction_started.emit()

func _on_interact_event_finished(_event: QuillaStoryCompiled, _next_event: String) -> void:
	interaction_finished.emit()

func get_all_actions() -> PackedStringArray:
	var result := PackedStringArray()
	for node in interact_event.data:
		if node.get("type", "") == "switch" and node["value"] == "INTERACT_VERB":
			for verb in node["choices"]:
				if not verb.is_empty():
					var split: PackedStringArray = verb.split("|")
					result.push_back(split[0].strip_edges().trim_prefix('"').trim_suffix('"'))
			
	return result
			
