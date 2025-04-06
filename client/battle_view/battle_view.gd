class_name BattleView extends CanvasLayer


func handle_action_item(action_batch: Dictionary) -> void:
	pass
	#var resolver := ActionBatchResolver.new(action_batch)
	#add_child(resolver)

class ActionBatchResolver extends Node:
	var keyframe_index: int = 0
	var action_batch: Dictionary
	var children_resolver: ActionBatchResolver
	
	func _init(action_batch_: Dictionary) -> void:
		action_batch = action_batch_
		var animate := create_animation()
		animate.keyframe.connect(_on_animate_keyframe)
	
	func _on_animate_keyframe() -> void:
		var action_list: Array = action_batch.get("ActionList", [])
		if keyframe_index < action_list.size():
			handle_action_item(action_list[keyframe_index])
		keyframe_index += 1
	
	func handle_action_item(action_item: Dictionary) -> void:
		var type: String = action_item.get("Type", "")
		if type == "ActionBatch":
			var resolver := ActionBatchResolver.new(action_item)
			add_child(resolver)
			children_resolver = resolver
		elif type == "Action":
			print("HandleAction")
	
	func create_animation() -> Animate:
		var animate := Animate.new()
		add_child(animate)
		return animate


class Animate extends Node:
	signal keyframe
	signal finished
	
	var animation_stage: int
	var is_paused: bool = false
	
	func _process(delta: float) -> void:
		if is_paused: return
		process_animation(animation_stage)
	
	func process_animation(stage: int) -> void:
		match stage:
			0:
				print("Animate 0")
				advance_stage()
			1:
				print("Animate 1+Keyframe")
				activate_keyframe()
			2:
				print("Animate 2")
				advance_stage()
			3:
				print("Animate END")
				activate_end()
	
	func advance_stage() -> void:
		animation_stage += 1
	
	func activate_end() -> void:
		finished.emit()
	
	func activate_keyframe() -> void:
		keyframe.emit()
		is_paused = true
