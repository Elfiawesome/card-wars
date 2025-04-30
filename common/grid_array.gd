class_name GridArray
extends RefCounted

var _data: Dictionary[Vector2i, Variant] = {}

var _min_coord := Vector2i(INF, INF)
var _max_coord := Vector2i(INF, INF)
var _is_empty: bool = true

func set_cell(coord: Vector2i, value: Variant) -> void:
	_data[coord] = value
	
	if _is_empty:
		_min_coord = coord
		_max_coord = coord
		_is_empty = false
	else:
		_min_coord = _min_coord.min(coord)
		_max_coord = _max_coord.max(coord)

func get_cell(coord: Vector2i, default: Variant = null) -> void:
	return _data.get(coord, default)

func has_cell(coord: Vector2i) -> bool:
	return _data.has(coord)

func remove_cell(coord: Vector2i) -> bool:
	return _data.erase(coord)

func clear() -> void:
	_data.clear()
	_min_coord = Vector2(INF, INF)
	_max_coord = Vector2(INF, INF)
	_is_empty = true

func get_row(y: int) -> Dictionary:
	var row_data: Dictionary = {}
	for coord: Vector2i in _data.keys():
		if coord.y == y:
			row_data[coord.x] = _data[coord]
	return row_data

func get_col(x: int) -> Dictionary:
	var col_data: Dictionary = {}
	for coord: Vector2i in _data.keys():
		if coord.x == x:
			col_data[coord.y] = _data[coord]
	return col_data

func get_all_rows() -> Dictionary:
	var all_rows: Dictionary = {}
	for coord: Vector2i in _data.keys():
		var value: Variant = _data[coord]
		if not all_rows.has(coord.y):
			all_rows[coord.y] = {}
		all_rows[coord.y][coord.x] = value
	return all_rows

func get_all_cols() -> Dictionary:
	var all_cols: Dictionary = {}
	for coord: Vector2i in _data.keys():
		var value: Variant = _data[coord]
		if not all_cols.has(coord.x):
			all_cols[coord.x] = {}
		all_cols[coord.x][coord.y] = value
	return all_cols

func get_occupied_cells() -> Array[Vector2i]:
	return _data.keys()

func get_occupied_cell_count() -> int:
	return _data.size()

func get_min_coord() -> Vector2i:
	return Vector2i.ZERO if _is_empty else _min_coord

func get_max_coord() -> Vector2i:
	return Vector2i(-1, -1) if _is_empty else _max_coord

func get_bounds() -> Rect2i:
	if _is_empty:
		return Rect2i(0, 0, 0, 0)
	else:
		var size := _max_coord - _min_coord + Vector2i.ONE
		return Rect2i(_min_coord, size)

func recalculate_bounds() -> void:
	if _data.is_empty():
		clear()
		return
	
	var first := true
	var new_min := Vector2i.ZERO
	var new_max := Vector2i.ZERO
	
	for coord: Vector2i in _data.keys():
		if first:
			new_min = coord
			new_max = coord
			first = false
		else:
			new_min = new_min.min(coord)
			new_max = new_max.max(coord)
	
	_min_coord = new_min
	_max_coord = new_max
	_is_empty = false

func pretty_print(
	empty_char: String = ".",
	cell_separator: String = " ",
	max_cell_width: int = 5,
	show_axes: bool = true
) -> void:
	if _is_empty:
		print("Grid is empty.")
		return
	var min_c: Vector2i = get_min_coord()
	var max_c: Vector2i = get_max_coord()
	var y_axis_width: int = 0
	var effective_max_cell_width: int = max(empty_char.length(), 1)
	var needs_truncation: bool = max_cell_width > 0
	if needs_truncation:
		effective_max_cell_width = max(effective_max_cell_width, max_cell_width)
	var x_axis_strings: Dictionary = {}
	if show_axes:
		var min_y_str_len := str(min_c.y).length()
		var max_y_str_len := str(max_c.y).length()
		y_axis_width = max(min_y_str_len, max_y_str_len) + 1
		for x in range(min_c.x, max_c.x + 1):
			var x_str := str(x)
			x_axis_strings[x] = x_str
			effective_max_cell_width = max(effective_max_cell_width, x_str.length())
	if not needs_truncation:
		for value: Vector2i in _data.values():
			effective_max_cell_width = max(effective_max_cell_width, str(value).length())
	var format_cell_str :=  func(input_str: String) -> String:
		var len := input_str.length()
		if needs_truncation and len > max_cell_width:
			if max_cell_width <= 3:
				return input_str.substr(0, max_cell_width)
			else:
				return input_str.substr(0, max_cell_width - 3) + "..."
		else:
			return input_str + (" ".repeat(effective_max_cell_width - len))
	if show_axes:
		var header_string: String = " ".repeat(y_axis_width)
		for x in range(min_c.x, max_c.x + 1):
			header_string += format_cell_str.call(x_axis_strings[x]) + cell_separator
		print(header_string)
	for y in range(max_c.y, min_c.y - 1, -1):
		var row_string: String = ""
		if show_axes:
			var y_label := str(y)
			row_string += (" ".repeat(y_axis_width - y_label.length() - 1)) + y_label + " "
		for x in range(min_c.x, max_c.x + 1):
			var coord := Vector2i(x, y)
			var cell_content_str: String
			if _data.has(coord):
				cell_content_str = str(_data[coord])
			else:
				cell_content_str = empty_char
			row_string += format_cell_str.call(cell_content_str) + cell_separator
		print(row_string)

func _to_string() -> String:
	return "Grid[Occupied Cells: %d, Bounds: %s]" % [get_occupied_cell_count(), str(get_bounds())]
