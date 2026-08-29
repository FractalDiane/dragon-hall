class_name TextBox
extends Control

signal text_finished()
signal close_animation_finished()

var fully_opened := false
var will_close := false

@onready var label := $Box/Text as RichTextLabel
@onready var box := $Box as NinePatchRect
@onready var anim_player := $AnimationPlayer as AnimationPlayer

func start(text: String, box_size: Rect2i) -> void:
	label.text = text
	box.position = box_size.position
	box.size = box_size.size
	box.pivot_offset.y = box_size.size.y / 2

func _process(_delta: float) -> void:
	if fully_opened and (Input.is_action_just_pressed(&"click") or Input.is_action_just_pressed(&"prompt")):
		will_close = true
		text_finished.emit()

func play_close_animation() -> void:
	anim_player.play_backwards(&"appear")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if will_close:
		close_animation_finished.emit()
		queue_free()
	else:
		fully_opened = true
