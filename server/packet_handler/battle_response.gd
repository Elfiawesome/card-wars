extends PacketHandlerServer
# Handles all incoming packets from clients that are interacting in battles

func run(server: Server, client: Server.ClientBase, _data: Array) -> void: 
	if client.battle_id != "":
		var battle := server.battle_manager.get_battle(client.battle_id)
		if battle:
			battle._handle_response(client.id, _data)
