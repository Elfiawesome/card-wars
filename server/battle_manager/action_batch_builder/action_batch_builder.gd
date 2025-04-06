class_name ActionBatchBuilder extends RefCounted

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY.register_object("CreateBattlefield", load("res://server/battle_manager/action_batch_builder/create_battlefield.gd").new())

static func get_builder(type: String) -> ActionBatchBuilder:
	return REGISTRY.get_object(type)

func create(_custom_params: Dictionary = {}) -> Dictionary:
	return {}

static func create_empty_batch(animation: Dictionary = {}) -> Dictionary:
	if animation.is_empty():
		return {
			"Type": "ActionBatch",
			"ActionList": []
		}
	else:
		return {
			"Type": "ActionBatch",
			"Animation": animation,
			"ActionList": []
		}

static func create_action(action_type: String, action_data: Dictionary) -> Dictionary:
	return {
		"Type": "Action",
		"ActionType": action_type,
		"ActionData": action_data
	}

static func create_animation(animation_type: String, animation_args: Dictionary, block: bool = false) -> Dictionary:
	return {
		"AnimationType": animation_type,
		"AnimationArgs": animation_args,
		"block": block
	}

static func set_animation_to_batch(action_batch: Dictionary, animation: Dictionary = {}) -> void:
	action_batch["Animation"] = animation

static func add_action_to_batch(action_batch: Dictionary, action: Dictionary = {}) -> void:
	if action_batch.has("ActionList"):
		var action_list: Array = action_batch["ActionList"]
		action_list.push_back(action)
