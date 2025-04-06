extends PacketHandlerServer

# Undo whatever we did in request
# Basically just remove whatever is left of the player off the server
# THe Server.Client object will be deleted by itself so dont need to worry about that

func run(server: Server, client: Server.ClientBase, _data: Array) -> void: 
	if client.id != "":
		if server.clients.has(client.id):
			server.clients.erase(client.id)
	else:
		pass
