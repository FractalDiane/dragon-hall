class_name InteractionComponent
extends Node3D

signal interaction_started()
signal interaction_finished()

@export var aliases: Array[String] = []
@export var interact_event: InkStoryCompiled = null
@export var proximity_levels_required: Dictionary[String, int] = {"look": 3}
@export var text_box_position := Rect2i()


func _ready() -> void:
	pass

func interact_with(action: String, proximity_level: int, box_position_: Rect2i, item := "") -> void:
	var event_player: EventPlayer
	var box_position := text_box_position if text_box_position != Rect2i() else box_position_
	var level_required := proximity_levels_required[action] if proximity_levels_required.has(action) else 0
	#if proximity_level <= level_required:
	event_player = EventPlaybackSubsystem.play_event(interact_event, self, box_position, action, item, {"range": proximity_level, "range_required": level_required})
	#else:
	#	event_player = EventPlaybackSubsystem.play_event(preload("res://dialogue/global/misc_responses.res"), self, box_position, "cant_reach", item)
		
	event_player.event_finished.connect(_on_interact_event_finished)
	interaction_started.emit()

func _on_interact_event_finished(_event: InkStoryCompiled, _next_event: String) -> void:
	interaction_finished.emit()
