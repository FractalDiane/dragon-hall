extends CanvasLayer

signal prompt_opened()
signal prompt_closed()
signal prompt_run(prompt: String)

var prompt_open := false

var in_editor := OS.has_feature("editor")
var debug_dragging := false
var debug_drag_start := Vector2()
var debug_drag_box: ColorRect = null

@onready var anim_player := $AnimationPlayer as AnimationPlayer
@onready var prompt := %Text as LineEdit

func _process(_delta: float) -> void:
	if prompt_open:
		if Input.is_action_just_pressed(&"prompt"):
			if not prompt.text.is_empty():
				prompt_run.emit(prompt.text.strip_edges())

			hide_prompt()
		elif Input.is_action_just_pressed(&"cancel"):
			hide_prompt()
			
	if in_editor:
		if Input.is_action_just_pressed(&"debug_drag"):
			debug_drag_box = ColorRect.new()
			debug_drag_start = get_tree().root.get_mouse_position()
			debug_drag_box.position = debug_drag_start
			add_child(debug_drag_box)
			debug_dragging = true
		elif Input.is_action_just_released(&"debug_drag"):
			print(Rect2i(debug_drag_box.position, debug_drag_box.size))
			debug_dragging = false
		elif debug_dragging:
			debug_drag_box.size = get_tree().root.get_mouse_position() - debug_drag_start

func show_prompt() -> void:
	prompt.text = ""
	anim_player.play(&"prompt")
	prompt.grab_focus()
	prompt_opened.emit()
	PlayerStateSubsystem.push_block_movement_source()

func hide_prompt() -> void:
	anim_player.play_backwards(&"prompt")
	
func is_prompt_open() -> bool:
	return prompt_open

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"prompt":
		if prompt_open:
			prompt_open = false
			prompt_closed.emit()
			PlayerStateSubsystem.pop_block_movement_source()
		else:
			prompt_open = true
