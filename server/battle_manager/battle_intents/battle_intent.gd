class_name BattleIntent extends RefCounted

static var REGISTRY := RegistrySimple.new()

var data: Dictionary = {}
var battle_logic: BattleLogic
var is_finished: bool

static func register() -> void:
	REGISTRY.register_object("example", load("res://server/battle_manager/battle_intents/example.gd"))

static func create(battle_logic_: BattleLogic, intent_type: String, intent_data: Dictionary) -> BattleIntent:
	var script: GDScript = REGISTRY.get_object(intent_type)
	if script:
		var intent: BattleIntent = script.new() as BattleIntent
		intent.battle_logic = battle_logic_
		intent.data = intent_data
		return intent
	return

func run() -> void:
	pass
func callback(callback_data: Dictionary) -> void:
	# Run when the client sends back any input to continue
	pass
func request_client_input() -> void:
	# Incomplete TODO: This is whern the intent requires client input, so we need to ask the client about the input
	# Then we will need to wait (need timer also) until the input is completed before we continue (we continue via callback?) Its a bit messy here
	pass
func complete_intent() -> void:
	is_finished = true


static func create_action(action_type: String, action_data: Dictionary = {}, recipients: Array = []) -> Dictionary:
	if recipients.is_empty():
		return {
			"Block": "Action",
			"Type": action_type,
			"Data": action_data
		}
	else:
		return {
			"Block": "Action",
			"Type": action_type,
			"Data": action_data,
			"Recipients": recipients
		}

func set_action_recipients(action: Dictionary, recipients: Array) -> void:
	action["Recipients"] = recipients
func get_action_recipients(action: Dictionary) -> Array:
	return action.get("Recipients", [])


static func create_batch(animation: Dictionary = {}) -> Dictionary:
	if animation.is_empty():
		return {
			"Block": "Batch",
			"List": []
		}
	else:
		return {
			"Block": "Batch",
			"Animation": animation,
			"List": []
		}

func set_batch_animation(batch: Dictionary, animation: Dictionary) -> void:
	batch["Animation"] = animation
func get_batch_animation(batch: Dictionary) -> Dictionary:
	return batch.get("Animation", create_animation("",{}))
func add_batch_action(batch: Dictionary, action: Dictionary) -> void:
	if "List" in batch:
		var list: Array = batch["List"]
		list.push_back(action)

static func create_animation(animation_type: String, animation_args: Dictionary = {}) -> Dictionary:
	return {
		"AnimationType": animation_type,
		"AnimationArgs": animation_args
	}
