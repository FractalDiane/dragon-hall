extends Control

@onready var anim_player := $AnimationPlayer as AnimationPlayer


func _on_button_load_pressed() -> void:
	PlayerStateSubsystem.load_game()
	$Fade.mouse_filter = MOUSE_FILTER_STOP
	await get_tree().create_timer(1.0).timeout
	PlayerStateSubsystem.pop_block_movement_source()
	queue_free()

func _on_button_exit_pressed() -> void:
	anim_player.play(&"fadeout")
	await get_tree().create_timer(1.2).timeout
	get_tree().quit()
