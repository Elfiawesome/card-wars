class_name ActionHandler extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	pass

static func get_action_handler(type: String) -> ActionHandler:
	return REGISTRY.get_object(type)

func run_as_client(client: GameSession, action_data: Dictionary) -> void:
	pass

func run_as_server(game_logic: BattleLogic, action_data: Dictionary) -> void:
	pass
