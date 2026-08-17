class_name Utils

static func bind_quilla_externals(story: QuillaStory, bind_impure_funcs: bool) -> void:
	story.bind_pure_function(&"has_item", PlayerStateSubsystem.has_item)
	story.bind_pure_function(&"has_item_count", PlayerStateSubsystem.has_item_count)
	story.bind_pure_function(&"is_human", func(): return PlayerStateSubsystem.get_current_form() == PlayerStateSubsystem.FORM_HUMAN)
	story.bind_pure_function(&"is_dragon", func(): return PlayerStateSubsystem.get_current_form() == PlayerStateSubsystem.FORM_DRAGON)
	story.bind_pure_function(&"is_dragon_small", func(): return PlayerStateSubsystem.get_current_form() == PlayerStateSubsystem.FORM_DRAGONSMALL)
	
	story.bind_pure_function(&"help_enabled", func(): return SettingsSubsystem.object_help)
	
	if bind_impure_funcs:
		story.bind_impure_function(&"game_over", PlayerStateSubsystem.game_over)
		
		story.bind_impure_function(&"add_item", PlayerStateSubsystem.add_item)
		story.bind_impure_function(&"pick_up_item", PlayerStateSubsystem.pick_up_item)
		
		story.bind_impure_function(&"push_library_button", EventBridgeSubsystem.push_library_button)
		
