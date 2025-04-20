class_name BattleActionHandler extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY._register_all_objects_in_folder("res://common/battle_action_handler/", 1)

static func get_battle_action_handler(action_handler_type: String) -> BattleActionHandler:
	return REGISTRY.get_object(action_handler_type)

func handle_as_client(_battle_view: BattleView, _action_data: Dictionary) -> void:
	pass

func handle_as_server(_battle_logic: BattleLogic, _action_data: Dictionary) -> Dictionary:
	# Here we will return values for SERVER use only
	# If we want to inject any new data into the action_data for client, we directly edit this action_data dict and it will be passed onto the client's handle_as_client
	return {}
