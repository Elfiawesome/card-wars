class_name BattleActionHandler extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	pass
	#REGISTRY.register_object("", load("").new())

static func get_battle_action_handler(action_handler_type: String) -> BattleActionHandler:
	return REGISTRY.get_object(action_handler_type)


func handle_as_client(battle_view: BattleView, action_data: Dictionary, server_result_data: Dictionary) -> void:
	pass

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	# Returns a 'server_result_data' to sent to client if there are data that can only be resolved after we finish running the action
	# For example, if we want an update stat data, but that data can only be retreived after we fully update it on the server side
	# If not, all normal action_data are meant to be sequential data, meaning it is meant to change (add, minus etc), not to update a value
	return {}
