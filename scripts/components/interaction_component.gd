class_name InteractionComponent
extends Node3D

signal interaction_started()
signal interaction_finished()

@export var aliases: Array[String] = []
@export var hidden := false
@export var can_pick_up := false
@export var interact_event: InkStoryCompiled = null
@export var proximity_levels_required: Dictionary[String, int] = {"look": 3}
@export var text_box_position := Rect2i()


func _ready() -> void:
	if OS.has_feature("editor") and interact_event == null:
		push_error("%s has no interact event set" % get_parent().get_path())
		
	if can_pick_up and PlayerStateSubsystem.is_item_picked_up(get_parent().get_path()):
		get_parent().queue_free()

func interact_with(action: String, proximity_level: int, box_position_: Rect2i, item := "") -> void:
	var event_player: EventPlayer
	var box_position := text_box_position if text_box_position != Rect2i() else box_position_
	var level_required := proximity_levels_required[action] if proximity_levels_required.has(action) else 0
	event_player = EventPlaybackSubsystem.play_event(interact_event, self, box_position, action, aliases[0] if item.is_empty() else item, {"range": proximity_level, "range_required": level_required})
		
	event_player.event_finished.connect(_on_interact_event_finished)
	interaction_started.emit()

func _on_interact_event_finished(_event: InkStoryCompiled, _next_event: String) -> void:
	interaction_finished.emit()
