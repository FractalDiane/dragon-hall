class_name EventPlayer
extends Node

signal event_finished(event: InkStoryCompiled, next_event: String)

enum {
	CONTENT_MODE_TEXT,
	CONTENT_MODE_CHOICE,
	CONTENT_MODE_END,
}

const DIALOGUE_BOX := preload("res://prefabs/ui/text_box.tscn")

var next_text := String()
var next_tags: Array[String] = []
var next_choices: Array[String] = []
var content_mode := CONTENT_MODE_TEXT

var current_dialogue: TextBox = null
var current_dialogue_size := Rect2i()

var caller: Node = null
var event_to_play_after := String()

@export var ink_story_file: InkStoryCompiled = null

var ink_story: InkStory = null

###############################################################################

func _init(event: InkStoryCompiled, caller_: Node, text_box_size: Rect2i, interact_verb: String, interact_item: String, set_variables := {}) -> void:
	ink_story_file = event
	caller = caller_
	current_dialogue_size = text_box_size
	
	ink_story = InkStory.new()
	ink_story.load_compiled_file(event)
	
	ink_story.set_variable(&"interact_verb", interact_verb)
	ink_story.set_variable(&"interact_item", interact_item)
	
	for vari in set_variables:
		ink_story.set_variable(vari, set_variables[vari])
	
	#Utils.bind_ink_externals(ink_story, true)
	
	#ink_story.bind_external_function(&"get_item_animation", got_item_animation)
	

func _ready() -> void:
	fetch_next_story_content()
	continue_story()
	

func fetch_next_story_content() -> void:
	if ink_story.can_continue():
		next_text = ink_story.continue_story()
		next_tags = ink_story.get_current_tags()
		content_mode = CONTENT_MODE_TEXT
	elif not ink_story.get_current_choices().is_empty():
		next_choices = ink_story.get_current_choices()
		next_tags = ink_story.get_current_tags()
		content_mode = CONTENT_MODE_CHOICE
	else:
		content_mode = CONTENT_MODE_END


func continue_story() -> void:
	match content_mode:
		CONTENT_MODE_TEXT:
			if not next_tags.is_empty():
				var remove_dialogue := execute_tag(next_tags.pop_front())
				if remove_dialogue and current_dialogue != null:
					current_dialogue.play_close_animation()
					current_dialogue.close_animation_finished.connect(_on_dialogue_finished.bind(true))
					current_dialogue = null
					
				return
				
			if next_text.is_empty() or next_text == "@":
				if current_dialogue != null:
					current_dialogue.play_close_animation()
					current_dialogue.close_animation_finished.connect(_on_dialogue_finished.bind(true))
				else:
					_on_dialogue_finished(false)
					
				return
				
			if current_dialogue == null:
				current_dialogue = DIALOGUE_BOX.instantiate() as TextBox
				get_tree().current_scene.add_child(current_dialogue)
				#HUD.add_dialogue_child(current_dialogue)
				current_dialogue.text_finished.connect(_on_dialogue_finished.bind(false))

			current_dialogue.start(next_text, current_dialogue_size)
		CONTENT_MODE_CHOICE:
			pass
		CONTENT_MODE_END:
			end_story()


func execute_tag(tag: String) -> bool:
	var split := tag.split(" ")
	match split[0]:
		"wait":
			var timer := get_tree().create_timer(float(split[1]))
			timer.timeout.connect(continue_story)
			return true
		"box":
			current_dialogue_size = Rect2i(int(split[1]), int(split[2]), int(split[3]), int(split[4]))
			
	continue_story()
	return false
	
	
func end_story() -> void:
	if current_dialogue != null:
		current_dialogue.play_close_animation()
		current_dialogue.close_animation_finished.connect(end_story_post_dialogue)
	else:
		end_story_post_dialogue()
	
	
func end_story_post_dialogue() -> void:
	event_finished.emit(ink_story_file, event_to_play_after)
	queue_free()
	
	
func _on_dialogue_finished(closed: bool) -> void:
	if closed:
		current_dialogue = null
		
	fetch_next_story_content()
	continue_story()
	
###############################################################################

#func got_item_animation(item_path: String) -> void:
#	(get_tree().current_scene.get_node(^"Player") as Player).play_got_item_animation(get_tree().current_scene.get_node(item_path))
