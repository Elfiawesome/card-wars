extends ActionBatchBuilder

func create(_custom_params: Dictionary = {}) -> Dictionary:
	var wrap_batch := create_empty_batch()
	var battlefield_batch := create_empty_batch()
	add_action_to_batch(battlefield_batch, create_action("CreateBattlefield", {}))
	add_action_to_batch(battlefield_batch, create_action("CreateBattlefield", {}))
	add_action_to_batch(battlefield_batch, create_action("CreateBattlefield", {}))
	add_action_to_batch(battlefield_batch, create_action("CreateBattlefield", {}))
	
	var other_batch := create_empty_batch()
	var other_animation := create_animation("Example", {})
	add_action_to_batch(other_batch, create_action("SomethingElse", {"Data": 0}))
	set_animation_to_batch(other_batch, other_animation)
	
	add_action_to_batch(wrap_batch, battlefield_batch)
	add_action_to_batch(wrap_batch, other_batch)
	return wrap_batch
