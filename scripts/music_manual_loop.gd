extends AudioStreamPlayer

@export var loop_time := 0.0

func _ready() -> void:
	get_tree().create_timer(loop_time).timeout.connect(_on_timer_timeout)
	max_polyphony = 3
	
func _on_timer_timeout() -> void:
	play()
	get_tree().create_timer(loop_time).timeout.connect(_on_timer_timeout)
