extends BattleActionHandler

func handle_as_client(battle_view: BattleView, action_data: Dictionary) -> void:
	var battlefield_id: String = action_data.get("id", "")
	if battlefield_id:
		var battlefield := battle_view.create_battlefield_container(battlefield_id)
		battle_view.add_child(battlefield)

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var id := battle_logic.create_battlefield()
	action_data["id"] = id
	return {"id": id}
