class_name BattleIntent extends RefCounted

static var REGISTRY := RegistrySimple.new()

var data: Dictionary = {}
var battle_logic: BattleLogic
var is_finished: bool

static func register() -> void:
	REGISTRY._register_all_objects_in_folder("res://server/battle_manager/battle_intents/")

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


# Helper action functions
enum ACTION_ITEM_BLOCK_TYPE {
	NONE,
	ACTION,
	BATCH,
}
static func get_action_item_block_type(action: Dictionary) -> ACTION_ITEM_BLOCK_TYPE:
	return action.get("Block", ACTION_ITEM_BLOCK_TYPE.NONE)

static func create_action(action_type: String, action_data: Dictionary = {}, recipients: Array = []) -> Dictionary:
	if recipients.is_empty():
		return {
			"Block": ACTION_ITEM_BLOCK_TYPE.ACTION,
			"Type": action_type,
			"Data": action_data
		}
	else:
		return {
			"Block": ACTION_ITEM_BLOCK_TYPE.ACTION,
			"Type": action_type,
			"Data": action_data,
			"Recipients": recipients
		}

static func set_action_recipients(action: Dictionary, recipients: Array) -> void:
	action["Recipients"] = recipients
static func get_action_recipients(action: Dictionary) -> Array:
	return action.get("Recipients", [])
static func get_action_type(action: Dictionary) -> String:
	return action.get("Type", "")
static func get_action_data(action: Dictionary) -> Dictionary:
	return action.get("Data", {})


static func create_batch(animation: Dictionary = {}) -> Dictionary:
	if animation.is_empty():
		return {
			"Block": ACTION_ITEM_BLOCK_TYPE.BATCH,
			"List": []
		}
	else:
		return {
			"Block": ACTION_ITEM_BLOCK_TYPE.BATCH,
			"Animation": animation,
			"List": []
		}
static func wrap_in_batch(actions: Array[Dictionary], animation: Dictionary = {}) -> Dictionary:
	var batch := create_batch(animation)
	batch["List"] = actions
	return batch

static func set_batch_animation(batch: Dictionary, animation: Dictionary) -> void:
	batch["Animation"] = animation
static func get_batch_animation(batch: Dictionary) -> Dictionary:
	return batch.get("Animation", {})
static func get_batch_list(batch: Dictionary) -> Array:
	return batch.get("List", [])
static func add_batch_action(batch: Dictionary, action: Dictionary) -> void:
	if "List" in batch:
		var list: Array = batch["List"]
		list.push_back(action)

static func create_animation(animation_type: String, animation_args: Dictionary = {}) -> Dictionary:
	return {
		"AnimationType": animation_type,
		"AnimationArgs": animation_args
	}
