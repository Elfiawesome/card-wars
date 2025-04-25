class_name AnimationClip extends Node

signal trigger_keyframe(action_item: Dictionary)
signal trigger_end()

var _paused: bool = true
var _has_ended: bool = false
var action_list: Array = []
var stage: int = 0
var args: Dictionary

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY.register_all_objects_in_folder("res://client/battle_view/animation_clips/")

static func get_animation_clip(animation_clip_type: String) -> AnimationClip:
	var gdscript: GDScript = REGISTRY.get_object(animation_clip_type)
	if gdscript:
		return gdscript.new()
	return AnimationClip.new()

func _init() -> void:
	pass

func start() -> void:
	_paused = false
	if !_has_ended:
		_process_animation_burst()

func _process(delta: float) -> void:
	if _paused or _has_ended: return
	_process_animation(delta)

func _process_animation_burst() -> void:
	animation_end()

func _process_animation(_delta: float) -> void:
	match stage:
		0: pass

func advance_stage() -> void: 
	stage += 1
	if !_paused && !_has_ended: _process_animation_burst()

func animation_keyframe() -> void:
	if action_list.size() > 0:
		var action: Dictionary = action_list.pop_front()
		trigger_keyframe.emit(action)

func animation_end() -> void:
	while action_list.size() > 0:
		if _paused:
			break
		animation_keyframe()
	
	if _paused or _has_ended: return
	_has_ended = true
	trigger_end.emit()
	queue_free()
