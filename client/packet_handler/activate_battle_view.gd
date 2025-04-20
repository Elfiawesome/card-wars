extends PacketHandlerClient

func run(game: GameSession, _data: Array) -> void:
	game.battle_view.visible = true
	game.world_view.visible = false
