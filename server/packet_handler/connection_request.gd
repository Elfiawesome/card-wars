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
	
	# Send this player into a battle
	var battle := server.battle_manager.create_battle()
	battle.connected_clients.push_back(client.id)
	client.send_data("ActivateBattleView", [])
	
	var batch_builder := ActionBatchBuilder.get_builder("CreateBattlefield")
	var batch := batch_builder.create()
	battle.commit_action_batch(batch)


func validate_data(data: Array) -> bool:
	if data.size() != 1: return false
	if !(data[0] is String): return false
	return true
