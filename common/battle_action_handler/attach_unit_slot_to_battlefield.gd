extends BattleActionHandler

func handle_as_client(battle_view: BattleView, action_data: Dictionary) -> void:
	var battlefield_id: String = action_data.get("battlefield_id", "")
	var unit_slot_layout: Array[Array] = action_data.get("unit_slot_layout", []) as Array[Array]
	
	
	var battlefield_container := battle_view.get_battlefield_container(battlefield_id)
	battle_view.add_child(battlefield_container)
	
	var card_seperation := Vector2(250, 350)
	var midpoint_offset := Vector2(unit_slot_layout.size() * card_seperation.x, unit_slot_layout[0].size() * card_seperation.y)/2
	if battlefield_container:
		for row_index in unit_slot_layout.size():
			var row := unit_slot_layout[row_index]
			for col_index in row.size():
				var unit_slot_id: String = row[col_index]
				var unit_slot_container := battle_view.get_unit_slot_container(unit_slot_id)
				if unit_slot_container:
					battlefield_container.add_child(unit_slot_container)
					unit_slot_container.position = Vector2(col_index * card_seperation.x, row_index * card_seperation.y) - midpoint_offset

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var battlefield_id: String = action_data.get("battlefield_id", "")
	var unit_slot_layout: Array[Array] = action_data.get("unit_slot_layout", []) as Array[Array]
	
	for row_index in unit_slot_layout.size():
		var row := unit_slot_layout[row_index]
		for col_index in row.size():
			var unit_slot_id: String = row[col_index]
			if !unit_slot_id: continue
			var unit_slot := battle_logic.get_unit_slot(unit_slot_id)
			if unit_slot:
				unit_slot.battlefield_id = battlefield_id
				unit_slot.coords = Vector2i(row_index, col_index)
	
	var battlefield := battle_logic.get_battlefield(battlefield_id)
	battlefield.unit_slots = unit_slot_layout
	return {}
