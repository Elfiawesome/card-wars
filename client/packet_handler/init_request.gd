extends PacketHandlerClient

func run(game: GameSession, _data: Array) -> void:
	game.network_connection.send_data("ConnectionRequest", [game.network_connection.username])
