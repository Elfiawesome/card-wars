class_name BattleView extends CanvasLayer

var action_item_queue: Array[Dictionary] = []
var animation_clip_queue: Array[AnimationClip] = []

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if !action_item_queue.is_empty():
		var action_item: Dictionary = action_item_queue.pop_front()
		handle_action_item(action_item)

func handle_action_item(action_item: Dictionary) -> void:
	var block := BattleActions.get_item_block_type(action_item)
	if block == BattleActions.BLOCK_TYPE.BATCH:
		handle_action_batch(action_item)
	elif block == BattleActions.BLOCK_TYPE.ACTION:
		var type := BattleActions.get_action_type(action_item)
		var data := BattleActions.get_action_data(action_item)
		_print_debug("Processing Action: %s - %s" % [type, data])

func handle_action_batch(batch: Dictionary) -> void:
	var list := BattleActions.get_batch_list(batch)
	var animation := BattleActions.get_batch_animation(batch)
	var animation_type := BattleActions.get_animation_type(animation)
	var animation_args := BattleActions.get_animation_args(animation)
	
	# Create a new animation clip
	var animation_clip := AnimationClip.get_animation_clip(animation_type)
	animation_clip.action_list = list
	animation_clip.args = animation_args
	animation_clip.trigger_keyframe.connect(handle_action_item)
	animation_clip.trigger_end.connect(
		func() -> void:
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
