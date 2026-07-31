extends Control

@onready var anim_player := $AnimationPlayer as AnimationPlayer

func _on_button_start_pressed() -> void:
	pass # Replace with function body.


func _on_button_continue_pressed() -> void:
	pass # Replace with function body.


func _on_button_exit_pressed() -> void:
	anim_player.play(&"fadeout")
	await anim_player.animation_finished
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fadein":
		($Music2 as AudioStreamPlayer).play()
