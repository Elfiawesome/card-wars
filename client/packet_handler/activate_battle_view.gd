extends PacketHandlerClient

func run(game: GameSession, data: Array) -> void:
	game.battle_view.visible = true
	game.world_view.visible = false
