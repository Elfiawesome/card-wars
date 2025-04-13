extends Node

func _ready() -> void:
	BattleActionHandler.register()
	register_client()
	register_server()

func register_client() -> void:
	PacketHandlerClient.register()

func register_server() -> void:
	PacketHandlerServer.register()
	BattleIntent.register()
