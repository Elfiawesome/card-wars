class_name BattleActions extends Object
# Global Helper class to create/read action as Dictionaries

enum BLOCK_TYPE {
	NONE,
	ACTION,
	BATCH,
}

enum BATCH_MODE { NONE, BLOCK, JOINED }

const KEY = {
	BLOCK = "b",
	TYPE = "t",
	DATA = "d",
	RECIPIENTS = "r",
	LIST = "l",
	MODE = "m",
	ANIMATION_BATCH = "a",
	ANIMATION = {
		TYPE = "t",
		ARGS = "a"
	}
}

const BATCH_START_CODE: String = "bs"
const BATCH_END_CODE: String = "be"
const ACTION_CODE: String = "a"

static func get_item_block_type(action: Dictionary) -> BLOCK_TYPE:
	return action.get(KEY.BLOCK, BLOCK_TYPE.NONE)

static func create_action(action_type: String, action_data: Dictionary = {}, recipients: Array = []) -> Dictionary:
	if recipients.is_empty():
		return {
			KEY.BLOCK: BLOCK_TYPE.ACTION,
			KEY.TYPE: action_type,
			KEY.DATA: action_data
		}
	else:
		return {
			KEY.BLOCK: BLOCK_TYPE.ACTION,
			KEY.TYPE: action_type,
			KEY.DATA: action_data,
			KEY.RECIPIENTS: recipients
		}
static func set_action_recipients(action: Dictionary, recipients: Array) -> void:
	action[KEY.RECIPIENTS] = recipients
static func get_action_recipients(action: Dictionary) -> Array:
	return action.get(KEY.RECIPIENTS, [])
static func get_action_type(action: Dictionary) -> String:
	return action.get(KEY.TYPE, "")
static func get_action_data(action: Dictionary) -> Dictionary:
	return action.get(KEY.DATA, {})


static func create_batch(animation: Dictionary = {}, mode: BATCH_MODE = BATCH_MODE.BLOCK) -> Dictionary:
	if animation.is_empty():
		return {
			KEY.BLOCK: BLOCK_TYPE.BATCH,
			KEY.LIST: [],
			KEY.MODE: mode
		}
	else:
		return {
			KEY.BLOCK: BLOCK_TYPE.BATCH,
			KEY.ANIMATION_BATCH: animation,
			KEY.LIST: [],
			KEY.MODE: mode
		}
static func wrap_in_batch(actions: Array[Dictionary], animation: Dictionary = {}, mode: BATCH_MODE = BATCH_MODE.BLOCK) -> Dictionary:
	var batch := create_batch(animation, mode)
	batch[KEY.LIST] = actions
	return batch

static func set_batch_animation(batch: Dictionary, animation: Dictionary) -> void:
	batch[KEY.ANIMATION_BATCH] = animation
static func set_batch_mode(batch: Dictionary, mode: BATCH_MODE) -> void:
	batch[KEY.MODE] = mode
static func get_batch_animation(batch: Dictionary) -> Dictionary:
	return batch.get(KEY.ANIMATION_BATCH, {})
static func get_batch_list(batch: Dictionary) -> Array:
	return batch.get(KEY.LIST, [])
static func get_batch_mode(batch: Dictionary) -> BATCH_MODE:
	return batch.get(KEY.MODE, BATCH_MODE.BLOCK)
static func add_batch_action(batch: Dictionary, action: Dictionary) -> void:
	if KEY.LIST in batch:
		var list: Array = batch[KEY.LIST]
		list.push_back(action)

static func create_animation(animation_type: String, animation_args: Dictionary = {}) -> Dictionary:
	return {
		KEY.ANIMATION.TYPE: animation_type,
		KEY.ANIMATION.ARGS: animation_args
	}
static func get_animation_type(animation: Dictionary) -> String:
	return animation.get(KEY.ANIMATION.TYPE, "")
static func get_animation_args(animation: Dictionary) -> Dictionary:
	return animation.get(KEY.ANIMATION.ARGS, {})
