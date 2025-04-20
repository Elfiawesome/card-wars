extends BattleActionHandler

func handle_as_client(_battle_view: BattleView, _action_data: Dictionary) -> void:
	pass

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var id := battle_logic.create_battlefield()
	action_data["id"] = id
	return {"id": id}
