extends BattleIntent

func run() -> void:
	if battle_logic.current_phase == battle_logic.Phase.None:
		var _r := battle_logic.commit_action(BattleActions.create_action("update_current_turn", {"Turn": 0, "Phase": battle_logic.Phase.Setup}))
		for player_id in battle_logic.player_instance:
			battle_logic.commit_intent("setup_battlefield")
		complete_intent()
		return
	
	if battle_logic.current_turn >= (battle_logic.player_order.size()-1):
		match battle_logic.current_phase:
			battle_logic.Phase.Setup:
				var _r := battle_logic.commit_action(BattleActions.create_action("update_current_turn", {"Turn": 0, "Phase": battle_logic.Phase.Attacking}))
			battle_logic.Phase.Attacking:
				var _r := battle_logic.commit_action(BattleActions.create_action("update_current_turn", {"Turn": 0, "Phase": battle_logic.Phase.Setup}))
			battle_logic.Phase.Resolve:
				pass
	else:
		var _r := battle_logic.commit_action(BattleActions.create_action("update_current_turn", {"Turn": battle_logic.current_turn + 1, "Phase": battle_logic.current_phase}))
	
	complete_intent()
