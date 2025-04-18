class_name RegistrySimple extends RefCounted

var _map: Dictionary[String, Object] = {}

func _init() -> void:
	pass

func get_object(name: String) -> Object:
	return _map.get(name)

# TODO: WARNING: remove all instances of _register and register them manually on release
# Unless I want the game to be moddable which would be kinda cool i guess
func _register_all_objects_in_folder(folder: String, instance_load_type: int = 0) -> void:
	for file_path in ResourceLoader.list_directory(folder):
		var pascal_name := _snake_to_pascal(file_path.split(".")[0])
		var object := ResourceLoader.load(folder + "/" + file_path)
		if instance_load_type == 0:
			register_object(pascal_name, object)
		elif instance_load_type == 1:
			if object is GDScript:
				register_object(pascal_name, object.new())
func _snake_to_pascal(snake_string: String) -> String:
	var components: PackedStringArray = snake_string.split("_")
	var pascal_string: String = ""
	for word in components:
		if !word.is_empty():
			pascal_string += word[0].to_upper() + word.substr(1)
	return pascal_string

func register_object(name: String, object: Variant) -> void:
	_map.set(name, object)

func get_registries() -> Array:
	return _map.keys()

func contains(name: String) -> bool:
	return _map.has(name)
