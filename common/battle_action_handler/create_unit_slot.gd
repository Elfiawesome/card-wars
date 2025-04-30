extends BattleActionHandler

func handle_as_client(battle_view: BattleView, action_data: Dictionary) -> void:
	var unit_slot_id: String = action_data.get("id", "")
	var battlefield_id: String = action_data.get("battlefield_id", "")
	var unit_position: Vector2i = action_data.get("unit_position", null)
	if unit_slot_id and battlefield_id:
		var unit := battle_view.create_unit_slot_container(unit_slot_id)
		var battlefield := battle_view.get_battlefield_container(battlefield_id)
		battlefield.add_unit_slot(unit_position, unit)

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var id := battle_logic.create_unit_slot()
	action_data["id"] = id
	
	return {}
