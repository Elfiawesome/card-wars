extends PacketHandlerClient

var pending_batches: Array = []

func run(_game: GameSession, data: Array) -> void:
	# TODO: Check if im even in a 'battle' game
	if true: pass
	var t: String = data[0]
	
	if t == "BatchStart":
		pending_batches.push_back({
			"Block": "Batch",
			"List": []
		})
	elif t == "BatchEnd":
		var completed_batch: Dictionary = pending_batches.pop_back()
		if !pending_batches.is_empty():
			var last_item: Dictionary = pending_batches[-1]
			var list:Array = last_item.get("List", []) as Array
			list.push_back(completed_batch)
		else:
			# Complete batch to system
			print(completed_batch)
	elif t == "Action":
		if !pending_batches.is_empty():
			var last_item: Dictionary = pending_batches[-1]
			var list:Array = last_item.get("List", []) as Array
			list.push_back(data[0])
		else:
			# Complete single aciton to system
			pass
