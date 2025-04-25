extends PacketHandlerClient

var pending_batches: Array = []

func run(game: GameSession, data: Array) -> void:
	# TODO: Check if im even in a 'battle' game
	if true: pass
	var t: String = data[0]
	
	if t == BattleActions.BATCH_START_CODE:
		var new_batch := BattleActions.create_batch()
		if data.size() > 1: BattleActions.set_batch_animation(new_batch, data[1])
		pending_batches.push_back(new_batch)
	elif t == BattleActions.BATCH_END_CODE:
		var completed_batch: Dictionary = pending_batches.pop_back()
		if !pending_batches.is_empty():
			# Get the parent batch as 'last_item'
			var last_item: Dictionary = pending_batches[-1]
			var list := BattleActions.get_batch_list(last_item)
			list.push_back(completed_batch)
		else:
			# Complete batch to system
			handle_action_item(game, completed_batch)
	elif t == BattleActions.ACTION_CODE:
		var action := BattleActions.create_action(data[1], data[2])
		if !pending_batches.is_empty():
			var last_item: Dictionary = pending_batches[-1]
			var list := BattleActions.get_batch_list(last_item)
			list.push_back(action)
		else:
			# Complete single aciton to system
			handle_action_item(game, action)


func handle_action_item(game: GameSession, action_item: Dictionary) -> void:
	game.battle_view.action_item_queue.push_back(action_item)
