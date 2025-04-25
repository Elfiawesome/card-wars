class_name PacketHandlerServer extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY.register_all_objects_in_folder("res://server/packet_handler/", 1)

static func get_handler(packet_type: String) -> PacketHandlerServer:
	return REGISTRY.get_object(packet_type)

func run(_server: Server, _client: Server.ClientBase, _data: Array) -> void: pass
