class_name PacketHandlerClient extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY.register_object("InitRequest", load("res://client/packet_handler/init_request.gd").new())
	REGISTRY.register_object("ForceDisconnect", load("res://client/packet_handler/force_disconnect.gd").new())
	REGISTRY.register_object("ActivateBattleView", load("res://client/packet_handler/activate_battle_view.gd").new())

static func get_handler(packet_type: String) -> PacketHandlerClient:
	return REGISTRY.get_object(packet_type)

func run(_game: GameSession, _data: Array) -> void: pass
