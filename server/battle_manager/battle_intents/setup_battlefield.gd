extends BattleIntent

func run() -> void:
	var battlefield_id: String = battle_logic.commit_action(BattleActions.create_action("create_battlefield")).get("id", "")
	if !battlefield_id: return
	var unit_slot_layout: Array[Vector2i] = [
		Vector2i(-1,0),
		Vector2i(0,0),
		Vector2i(1,0),
		Vector2i(0,1)
	]
	
	for unit_position in unit_slot_layout:
		battle_logic.commit_action(BattleActions.create_action("create_unit_slot", {
			"battlefield_id": battlefield_id,
			"unit_position": unit_position
		}))
	
	complete_intent()
