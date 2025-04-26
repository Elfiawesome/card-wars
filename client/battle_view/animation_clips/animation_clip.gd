class_name AnimationClip extends Node

signal keyframe_triggered()
signal end_triggered()

static var REGISTRY := RegistrySimple.new()

static func register() -> void:
	REGISTRY.register_all_objects_in_folder("res://client/battle_view/animation_clips/")

static func get_animation_clip(animation_type: String, animation_args: Dictionary = {}) -> AnimationClip:
	var gdscript: GDScript = REGISTRY.get_object(animation_type)
	var animation_clip: AnimationClip
	if gdscript:
		animation_clip = gdscript.new() as AnimationClip
	else:
		animation_clip = AnimationClip.new()
	animation_clip.args = animation_args
	return animation_clip

var args: Dictionary
var _is_paused: bool = false
# TODO: Skip per batch and skip whole batch and parent batches
var _is_skipping: bool = false
var stage: int = 0

func start() -> void:
	_is_paused = false
	proceess_animation_burst()

func _process(delta: float) -> void:
	if _is_paused: return
	proceess_animation(delta)

func proceess_animation(_delta: float) -> void:
	match stage:
		0: pass

func proceess_animation_burst() -> void:
	match stage:
		0: pass

func advance_stage() -> void:
	stage += 1
	if _is_paused: return
	proceess_animation_burst()

func pause() -> void:
	_is_paused = true

func resume() -> void:
	_is_paused = false
	proceess_animation_burst()

func skip() -> void:
	if _is_skipping: return # Already skipping
	_is_skipping = true
	trigger_end()

func stop() -> void:
	pass

func trigger_keyframe() -> void: keyframe_triggered.emit()

func trigger_end() -> void:
	end_triggered.emit()
	stop()
	queue_free()
