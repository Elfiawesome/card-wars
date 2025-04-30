class_name BattlefieldContainer extends Control

var id: String

var grid: Dictionary[Vector2i, UnitSlotContainer]
var actual_size: Vector2

var scene := preload("res://client/battle_view/unit_slot_container.tscn")

func _ready() -> void:
	pass

func add_unit_slot(unit_position: Vector2i, unit_slot: UnitSlotContainer) -> void:
	if !unit_slot: return
	if unit_position in grid: return
	grid[unit_position] = unit_slot
	add_child(unit_slot)
	arrange_unit_slots()

func arrange_unit_slots() -> void:
	var unit_slot_size := Vector2(210.5, 318)
	var unit_spacing := Vector2(30, 30)
	
	var min_coord := Vector2i(INF, INF)
	var max_coord := Vector2i(-INF, -INF)
	
	for unit_pos in grid:
		min_coord.x = min(min_coord.x, unit_pos.x)
		min_coord.y = min(min_coord.y, unit_pos.y)
		max_coord.x = max(max_coord.x, unit_pos.x)
		max_coord.y = max(max_coord.y, unit_pos.y)
	
	var min_visual_pos := Vector2(min_coord) * (unit_slot_size + unit_spacing)
	var max_visual_pos := Vector2(max_coord) * (unit_slot_size + unit_spacing)
	
	var total_required_size := max_visual_pos - min_visual_pos + unit_slot_size
	actual_size = total_required_size
	pivot_offset = total_required_size/2
	
	var b_tween := create_tween()
	b_tween.set_parallel(true)
	b_tween.tween_property(self, "size:x", total_required_size.x, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	b_tween.tween_property(self, "size:y", total_required_size.y, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for unit_position in grid:
		var unit_slot := grid[unit_position]
		var ideal_pos := Vector2(unit_position) * (unit_slot_size + unit_spacing)
		var relative_pos := ideal_pos - min_visual_pos
		
		var tween := unit_slot.create_tween()
		unit_slot.position = total_required_size/2 - unit_slot_size/2
		unit_slot.scale = Vector2.ZERO
		tween.set_parallel(true)
		tween.tween_property(unit_slot, "position", relative_pos, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		tween.tween_property(unit_slot, "scale", Vector2.ONE, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
