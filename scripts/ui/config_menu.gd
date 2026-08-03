class_name ConfigMenu
extends Control

signal back_pressed()

const CONFIG_DESCRIPTIONS: Array[String] = [
	"The volume of the sound effects.",
	"The volume of the music.",
	"If ON, a cursor appears in the world to show where you'll move.",
	'If ON, you can use the "help" command on an object to see what actions you can take with it.',
	'If ON, some info about assist mode here lkaj;hnsdf',
]

@export var archipelago_enabled := false

@onready var sfx_volume := %LabelSfxVolume as Label
@onready var music_volume := %LabelMusicVolume as Label
@onready var cursor := %ButtonCursor as Button
@onready var object_help := %ButtonHelp as Button
@onready var assist_mode := %ButtonAssist as Button
@onready var description := $Description as Label

func _ready() -> void:
	SettingsSubsystem.load_settings()
	update_settings()
	if not archipelago_enabled:
		($Settings/Archipelago as Control).hide()
	
func update_settings() -> void:
	sfx_volume.text = str(SettingsSubsystem.sfx_volume)
	music_volume.text = str(SettingsSubsystem.music_volume)
	cursor.text = "ON" if SettingsSubsystem.cursor else "OFF"
	object_help.text = "ON" if SettingsSubsystem.object_help else "OFF"
	assist_mode.text = "ON" if SettingsSubsystem.assist_mode else "OFF"
	
####################################################################################################

func _on_button_sfx_down_pressed() -> void:
	SettingsSubsystem.sfx_volume = max(SettingsSubsystem.sfx_volume - 1, 0)
	update_settings()

func _on_button_sfx_up_pressed() -> void:
	SettingsSubsystem.sfx_volume = min(SettingsSubsystem.sfx_volume + 1, 10)
	update_settings()

func _on_button_music_down_pressed() -> void:
	SettingsSubsystem.music_volume = max(SettingsSubsystem.music_volume - 1, 0)
	update_settings()

func _on_button_music_up_pressed() -> void:
	SettingsSubsystem.music_volume = min(SettingsSubsystem.music_volume + 1, 10)
	update_settings()

func _on_button_cursor_pressed() -> void:
	SettingsSubsystem.cursor = not SettingsSubsystem.cursor
	update_settings()

func _on_button_help_pressed() -> void:
	SettingsSubsystem.object_help = not SettingsSubsystem.object_help
	update_settings()

func _on_button_assist_pressed() -> void:
	SettingsSubsystem.assist_mode = not SettingsSubsystem.assist_mode
	update_settings()

func _on_button_back_pressed() -> void:
	back_pressed.emit()

####################################################################################################

func _on_volume_sound_mouse_entered() -> void:
	description.text = CONFIG_DESCRIPTIONS[0]


func _on_volume_music_mouse_entered() -> void:
	description.text = CONFIG_DESCRIPTIONS[1]


func _on_cursor_mouse_entered() -> void:
	description.text = CONFIG_DESCRIPTIONS[2]


func _on_help_command_mouse_entered() -> void:
	description.text = CONFIG_DESCRIPTIONS[3]


func _on_assist_mode_mouse_entered() -> void:
	description.text = CONFIG_DESCRIPTIONS[4]


func _on_section_mouse_exited() -> void:
	description.text = ""
