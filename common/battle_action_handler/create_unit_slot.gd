extends BattleActionHandler

func handle_as_client(battle_view: BattleView, action_data: Dictionary) -> void:
	var unit_slot_id: String = action_data.get("id", "")
	if unit_slot_id:
		var unit := battle_view.create_unit_slot_container(unit_slot_id)
		battle_view.get_battlefield_container(battle_view.battlefield_containers.keys()[0]).add_child(unit)

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var id := battle_logic.create_unit_slot()
	action_data["id"] = id
	return {"id": id}
