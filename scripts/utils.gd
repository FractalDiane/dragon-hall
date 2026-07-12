class_name Utils

static func bind_ink_externals(story: InkStory, bind_impure_funcs: bool) -> void:
	story.bind_external_function(&"has_item", PlayerStateSubsystem.has_item, true)
	story.bind_external_function(&"has_item_count", PlayerStateSubsystem.has_item_count, true)
	story.bind_external_function(&"is_human", func(): return PlayerStateSubsystem.get_current_form() == PlayerStateSubsystem.FORM_HUMAN, true)
	story.bind_external_function(&"is_dragon", func(): return PlayerStateSubsystem.get_current_form() == PlayerStateSubsystem.FORM_DRAGON, true)
	story.bind_external_function(&"is_dragon_small", func(): return PlayerStateSubsystem.get_current_form() == PlayerStateSubsystem.FORM_DRAGONSMALL, true)
	
	if bind_impure_funcs:
		story.bind_external_function(&"add_item", PlayerStateSubsystem.add_item)
		story.bind_external_function(&"pick_up_item", PlayerStateSubsystem.pick_up_item)
		
		story.bind_external_function(&"push_library_button", EventBridgeSubsystem.push_library_button)
