extends AnimationClip

var timer: Timer = Timer.new()

func _process_animation_burst() -> void:
	match stage:
		0:
			animation_keyframe()
			advance_stage()
		1:
			print("Wow fancy")
