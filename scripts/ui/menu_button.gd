class_name DhMenuButton
extends Button

func _ready() -> void:
	var sound_hover := AudioStreamPlayer.new()
	sound_hover.stream = preload("res://audio/ui/540269__zepurple__hover-over-a-button.wav")
	add_child(sound_hover)
	
	var sound_click := AudioStreamPlayer.new()
	sound_click.stream = preload("res://audio/ui/364531__christopherderp__swords-clash-high-quality-3.wav")
	sound_click.volume_db = -8.0
	add_child(sound_click)
	
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(release_focus)
	focus_entered.connect(sound_hover.play)
	pressed.connect(sound_click.play)
