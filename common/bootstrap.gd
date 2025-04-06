extends Node

func _ready() -> void:
	ActionHandler.register()
	register_client()
	register_server()

func register_client() -> void:
	PacketHandlerClient.register()

func register_server() -> void:
	ActionBatchBuilder.register()
	PacketHandlerServer.register()
