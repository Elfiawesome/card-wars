extends PacketHandlerServer
## IMPORTANT BECAUSE WE DO THE INITIALIZING AND HANDSHAKE HERE!

func run(server: Server, client: Server.ClientBase, data: Array) -> void: 
	if !validate_data(data): return
	
	if client.state == client.State.PLAY:
		# Meaning the client tried to do a connection request again for some reason
		return
	
	client.state = client.State.REQUEST
	
	var username: String = data[0]
	var hash_id := username
	if hash_id in server.clients:
		client.force_disconnect("A username is already in this server!")
		return
	
	server.clients[hash_id] = client
	client.id = hash_id
	client.state = client.State.PLAY
	
	# Create Battle
	var battle: BattleLogic
	if server.battle_manager._battles.is_empty():
		battle = server.battle_manager.create_battle()
	else:
		battle = server.battle_manager._battles.get(server.battle_manager._battles.keys()[0])
	client.battle_id = battle.id
	
	# Add client id into the connected clients for networking broadcasting
	var player := battle.PlayerInstance.new(battle.generate_id(), battle)
	battle.player_instance[player.id] = player
	player.client_id = client.id
	battle.player_order.push_back(player.id)
	# Add client id into the connected clients for networking broadcasting
	battle.connected_clients.push_back(client.id)
	battle.client_to_player_instance[client.id] = player.id
	
	# Send this player into a battle
	client.send_data("activate_battle_view", [])
	
	#if battle.player_instance.size() == 1:
		#battle.commit_intent("advance_turn")

func validate_data(data: Array) -> bool:
	if data.size() != 1: return false
	if !(data[0] is String): return false
	return true
