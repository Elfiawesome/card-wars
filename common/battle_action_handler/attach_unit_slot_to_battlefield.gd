extends BattleActionHandler

func handle_as_client(_battle_view: BattleView, _action_data: Dictionary) -> void:
	pass

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
