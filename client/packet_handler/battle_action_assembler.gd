extends PacketHandlerClient

var pending_batches: Array = []

func run(game: GameSession, data: Array) -> void:
	# TODO: Check if im even in a 'battle' game
	if true: pass
	var t: String = data[0]
	
	if t == "BatchStart":
		var new_batch := {
			"Block": "Batch",
			"List": []
		}
		if data.size() > 1: new_batch["Animation"] = data[1]
		pending_batches.push_back(new_batch)
	elif t == "BatchEnd":
		var completed_batch: Dictionary = pending_batches.pop_back()
		if !pending_batches.is_empty():
			var last_item: Dictionary = pending_batches[-1]
			var list:Array = last_item.get("List", []) as Array
			list.push_back(completed_batch)
		else:
			# Complete batch to system
			handle_action_item(game, completed_batch)
	elif t == "Action":
		var action := {
			"Block": "Action",
			"Type": data[1],
			"Data": data[2]
		}
		if !pending_batches.is_empty():
			var last_item: Dictionary = pending_batches[-1]
			var list:Array = last_item.get("List", []) as Array
			list.push_back(action)
		else:
			# Complete single aciton to system
			handle_action_item(game, action)


func handle_action_item(game: GameSession, action_item: Dictionary) -> void:
	game.battle_view.action_item_queue.push_back(action_item)
	print("=")
	print(JSON.stringify(game.battle_view.action_item_queue))
