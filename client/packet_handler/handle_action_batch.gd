extends PacketHandlerClient

func run(game: GameSession, data: Array) -> void:
	# TODO: Check if im even in a 'battle' game
	if true: pass
	
	# Hypothetical way to format a data as just [ActionBatch] for now
	var action_batch: Dictionary = data[0]
	# TODO: handle_action_item
	game.battle_view.handle_action_item(action_batch)
