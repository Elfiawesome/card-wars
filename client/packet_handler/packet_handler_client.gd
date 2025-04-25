class_name PacketHandlerClient extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY.register_all_objects_in_folder("res://client/packet_handler/", 1)

static func get_handler(packet_type: String) -> PacketHandlerClient:
	return REGISTRY.get_object(packet_type)

func run(_game: GameSession, _data: Array) -> void: pass
