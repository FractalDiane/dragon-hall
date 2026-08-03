extends Node

var sfx_volume := 7:
	get:
		return sfx_volume
	set(value):
		sfx_volume = value
		save_settings()
		
var music_volume := 7:
	get:
		return music_volume
	set(value):
		music_volume = value
		save_settings()
		
var cursor := true:
	get:
		return cursor
	set(value):
		cursor = value
		save_settings()
		
var object_help := false:
	get:
		return object_help
	set(value):
		object_help = value
		save_settings()
		
var assist_mode := false:
	get:
		return assist_mode
	set(value):
		assist_mode = value
		save_settings()
		
####################################################################################################

const SAVE_FILE_PATH := "user://settings.dat"

func save_settings() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	
	file.store_8(sfx_volume)
	file.store_8(music_volume)
	file.store_8(int(cursor))
	file.store_8(int(object_help))
	file.store_8(int(assist_mode))
	
	file.close()


func load_settings() -> void:
	var file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file != null:
		sfx_volume = file.get_8()
		music_volume = file.get_8()
		cursor = bool(file.get_8())
		object_help = bool(file.get_8())
		assist_mode = bool(file.get_8())
		
		file.close()
