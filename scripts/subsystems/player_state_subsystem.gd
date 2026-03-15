extends Node

var block_movement_sources := 0

func push_block_movement_source() -> void:
	block_movement_sources += 1
	
func pop_block_movement_source() -> void:
	block_movement_sources -= 1
	if block_movement_sources < 0:
		push_error("Imbalanced block movement sources stack")
		block_movement_sources = 0

func can_player_move() -> bool:
	return block_movement_sources == 0
