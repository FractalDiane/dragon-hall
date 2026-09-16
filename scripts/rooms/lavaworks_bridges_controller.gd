class_name LavaworksBridgesHandler
extends Node

@export var sound_lever: AudioStreamPlayer3D

#@export var anim_player_bridge1: AnimationPlayer
#@export var anim_player_bridge2: AnimationPlayer
#@export var anim_player_bridge3: AnimationPlayer

@export var anim_players: Array[AnimationPlayer] = []
@export var navmeshes: Array[NavigationRegion3D] = []

var lever_flipped := false

var bridges_extended := 0

func flip_lever() -> void:
	PlayerStateSubsystem.push_block_movement_source()
	sound_lever.play()
	lever_flipped = not lever_flipped
	if lever_flipped:
		anim_players[0].play(&"extend")
		anim_players[1].play(&"retract")
		PlayerStateSubsystem.give_flag(&"lavaworks_lever_flipped")
	else:
		anim_players[1].play(&"extend")
		anim_players[0].play(&"retract")
		PlayerStateSubsystem.take_flag(&"lavaworks_lever_flipped")
		
	await anim_players[0].animation_finished
	
	bridges_extended |= int(lever_flipped)
	bridges_extended |= int(not lever_flipped) * 2
	
	update_navmeshes()
	PlayerStateSubsystem.pop_block_movement_source()

func update_navmeshes() -> void:
	for i in range(len(navmeshes)):
		navmeshes[i].enabled = bridges_extended | (1 << i)
