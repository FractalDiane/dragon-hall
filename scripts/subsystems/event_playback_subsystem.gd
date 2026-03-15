extends Node

signal event_finished(event: InkStoryCompiled)

func play_event(event: InkStoryCompiled, caller: Node, text_box_size := Rect2i(), interact_verb := "", interact_item := "") -> EventPlayer:
	if event != null:
		var player := EventPlayer.new(event, caller, text_box_size, interact_verb, interact_item)
		get_tree().current_scene.add_child(player)
		
		PlayerStateSubsystem.push_block_movement_source()
		
		# it just gets destroyed immediately if there's no text in it
		if not player.is_queued_for_deletion():
			player.event_finished.connect(_on_event_finished)
		else:
			_on_event_finished(event, player.event_to_play_after)
			
		return player
	else:
		return null

func _on_event_finished(event: InkStoryCompiled, play_next: String) -> void:
	PlayerStateSubsystem.pop_block_movement_source()
	if not play_next.is_empty():
		play_event(load("res://dialogue/" + play_next), null)
		
	event_finished.emit(event)
