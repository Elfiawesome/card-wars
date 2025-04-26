class_name RegistrySimple extends RefCounted

var _map: Dictionary[String, Object] = {}

func _init() -> void:
	pass

func get_object(name: String) -> Object:
	return _map.get(name)

func register_all_objects_in_folder(folder: String, instance_load_type: int = 0) -> void:
	for file_path in ResourceLoader.list_directory(folder):
		var id := file_path.split(".")[0]
		var object := ResourceLoader.load(folder + "/" + file_path)
		if instance_load_type == 0:
			register_object(id, object)
		elif instance_load_type == 1:
			if object is GDScript:
				register_object(id, object.new())

func register_object(name: String, object: Variant) -> void:
	_map.set(name, object)

func get_registries() -> Array:
	return _map.keys()

func contains(name: String) -> bool:
	return _map.has(name)
