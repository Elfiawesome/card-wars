class_name BattleView extends CanvasLayer

@onready var animation_handler: AnimationHandler = $AnimationHandler
var action_item_queue: Array[Dictionary] = []
var animation_clip_queue: Array[AnimationClip] = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if !action_item_queue.is_empty():
		var action_item: Dictionary = action_item_queue.pop_front()
		handle_action_item(action_item)

func handle_action_item(action_item: Dictionary) -> void:
	var block: String = action_item.get("Block", "")
	if block == "Batch":
		handle_action_batch(action_item)
	elif block == "Action":
		var type: String = action_item.get("Type")
		var data: Dictionary = action_item.get("Data", {}) as Dictionary
		_print_debug("Processing Action: %s - %s" % [type, data])

func handle_action_batch(batch: Dictionary) -> void:
	var list: Array = batch.get("List", []) as Array
	var animation: Dictionary = batch.get("Animation", {}) as Dictionary
	var animation_type: String = animation.get("Type", {}) as String
	var animation_args: Dictionary = animation.get("Args", {}) as Dictionary
	
	# Create a new animation clip
	var animation_clip := AnimationClip.get_animation_clip(animation_type)
	animation_clip.action_list = list
	animation_clip.args = animation_args
	animation_clip.trigger_keyframe.connect(handle_action_item)
	animation_clip.trigger_end.connect(
		func(animation_clip: AnimationClip) -> void:
			animation_clip_queue.remove_at(animation_clip_queue.size()-1)
			if animation_clip_queue.size() > 0:
				animation_clip_queue[-1].start()
	)
	add_child(animation_clip)
	animation_clip_queue.push_back(animation_clip)
	
	# Pause the previous batch in favour of this new one first
	if animation_clip_queue.size() > 1: animation_clip_queue[-2]._paused = true
	
	animation_clip.start()



var _indent_size: int = 0
func _print_debug(msg: String, indent_change:int = 0, before: bool = true) -> void:
	if before: _indent_size += indent_change
	print("[%s]: %s%s" % [Time.get_ticks_usec(), "    ".repeat(max(_indent_size, 0)), msg])
	if !before: _indent_size += indent_change
