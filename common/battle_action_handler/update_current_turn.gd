extends BattleActionHandler

func handle_as_client(battle_view: BattleView, action_data: Dictionary) -> void:
	battle_view.debug_label.text = (
		"Turn: " + str(action_data.get("Turn", -1)) +
		"\nPhase: " + str(action_data.get("Phase", -1))
	)

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var turn: int = action_data.get("Turn", -1)
	var phase: int = action_data.get("Phase", -1)
	battle_logic.current_turn = turn
	battle_logic.current_phase = phase
	return {}
