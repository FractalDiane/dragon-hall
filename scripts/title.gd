extends Control

@onready var anim_player := $AnimationPlayer as AnimationPlayer
@onready var settings_menu := $ConfigMenu as Control

const CHEAT_CODE := "DRAGON"
var cheat_code_progress := ""

const CONFIG_DESCRIPTIONS: Array[String] = [
	"The volume of the sound effects.",
	"The volume of the music.",
	"If ON, a cursor appears in the world to show where you'll move.",
	'If ON, you can use the "help" command on an object to see what actions you can take with it.',
	'If ON, some info about assist mode here lkaj;hnsdf',
]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.is_echo() and not event.is_released():
		cheat_code_progress += event.as_text_keycode()
		if cheat_code_progress == CHEAT_CODE:
			$SoundClick.play()
		elif CHEAT_CODE.substr(0, len(cheat_code_progress)) != cheat_code_progress:
			cheat_code_progress = ""


func _on_button_start_pressed() -> void:
	anim_player.play(&"fadeout")
	await anim_player.animation_finished
	await get_tree().create_timer(3.0).timeout
	PlayerStateSubsystem.change_scene("res://scenes/game_maps/hall.tscn", ^"MarkerStart")


func _on_button_continue_pressed() -> void:
	settings_menu.show()


func _on_button_exit_pressed() -> void:
	anim_player.play(&"fadeout")
	await anim_player.animation_finished
	await get_tree().create_timer(0.25).timeout
	get_tree().quit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fadein":
		($Music2 as AudioStreamPlayer).play()


func _on_button_back_pressed() -> void:
	settings_menu.hide()
