extends BattleActionHandler

func handle_as_client(battle_view: BattleView, action_data: Dictionary) -> void:
	var phase_names := {
		-1: "No Key",
		BattleLogic.Phase.None: "None",
		BattleLogic.Phase.Setup: "Setup",
		BattleLogic.Phase.Attacking: "Attacking",
		BattleLogic.Phase.Resolve: "Resolve",
	}
	
	
	battle_view.debug_label.text = (
		"Turn: " + str(action_data.get("Turn", -1)) +
		"\nPhase: " + str(phase_names.get(action_data.get("Phase", -1), "Unkown")) + 
		"\nPlayer Id: " + str(action_data.get("PlayerID", ""))
	)

func handle_as_server(battle_logic: BattleLogic, action_data: Dictionary) -> Dictionary:
	var turn: int = action_data.get("Turn", -1)
	var phase: int = action_data.get("Phase", -1)
	battle_logic.current_turn = turn
	battle_logic.current_phase = phase as BattleLogic.Phase
	
	
	var current_turn_of_player_id := battle_logic.player_order[battle_logic.current_turn]
	
	action_data["PlayerID"] = current_turn_of_player_id
	
	battle_logic.player_response_limited = true
	battle_logic.allowed_player_responses.clear()
	if !(current_turn_of_player_id in battle_logic.allowed_player_responses):
		battle_logic.allowed_player_responses.push_back(current_turn_of_player_id)
	
	return {}
