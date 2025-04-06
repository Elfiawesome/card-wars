extends Node

var instance_num := 0
var username: String
var pid: int

func _ready() -> void:
	_get_instance_number()
	#if instance_num == 0: pid = OS.create_process("python", ["c:/Users/elfia/OneDrive/Desktop/cws-3/main.py"], true)

func _get_instance_number() -> void:
	if OS.is_debug_build():
		instance_num = int(OS.get_cmdline_args()[1])
		username = "Elfiawesome" + str(instance_num)
		var screen_size := Vector2(DisplayServer.screen_get_usable_rect().size)
		
		get_window().title = str(instance_num)
		get_window().size = screen_size/2
		
		
		match instance_num:
			0: get_window().position = Vector2(0,40) + Vector2(0, 0)
			1: get_window().position = Vector2(0,40) + Vector2(screen_size.x/2, 0)
			2: get_window().position = Vector2(0,40) + Vector2(0, screen_size.y/2)
			3: get_window().position = Vector2(0,40) + Vector2(screen_size.x/2, screen_size.y/2)

func _generate_unique_username() -> void:
	pass
