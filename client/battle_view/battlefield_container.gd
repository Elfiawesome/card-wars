class_name BattlefieldContainer extends Control

var id: String

var grid: Dictionary[Vector2i, UnitSlotContainer]

var scene := preload("res://client/battle_view/unit_slot_container.tscn")

func _ready() -> void:
	pass

func add_unit_slot(unit_position: Vector2i, unit_slot: UnitSlotContainer) -> void:
	grid[unit_position] = unit_slot
	add_child(unit_slot)
	arrange_unit_slots()

func arrange_unit_slots() -> void:
	var min_position: Vector2 = Vector2.ZERO
	var max_position: Vector2 = Vector2.ZERO
	
	var is_first: bool = true
	#var unit_size: Vector2 = Vector2(210.5, 318)
	for unit_position in grid:
		var unit_slot := grid[unit_position]
		unit_slot.position = unit_position * 300
		
		if is_first:
			min_position = unit_slot.position
			max_position = unit_slot.position
			is_first = false
		else:
			min_position = min_position.min(unit_slot.position)
			max_position = max_position.max(unit_slot.position)
	size = -min_position + max_position
	
	for unit_position in grid:
		grid[unit_position].position
