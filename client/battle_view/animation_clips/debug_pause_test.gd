extends AnimationClip

var timer: Timer = Timer.new()

func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(advance_stage)

func proceess_animation_burst() -> void:
	match stage:
		0: timer.start(1)
		1:
			trigger_keyframe()
			advance_stage()
		2: timer.start(1)
		3:
			trigger_keyframe()
			advance_stage()
		4: timer.start(1)
		5:
			trigger_keyframe()
			advance_stage()
		6: timer.start(1)
		7:
			trigger_keyframe()
			advance_stage()
		8: timer.start(1)
		9:
			trigger_keyframe()
			advance_stage()
		10: trigger_end()
