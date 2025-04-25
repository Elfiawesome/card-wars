extends BattleIntent

func run() -> void:
	var battlefield_id: String = battle_logic.commit_action(BattleActions.create_action("create_battlefield")).get("id", "")
	if !battlefield_id: return
	var unit_slot_layout: Array[Array] = [["#","#","#"],[" ","#"," "]]
	
	for row_index in unit_slot_layout.size():
		var row := unit_slot_layout[row_index]
		var new_row: Array[String] = []
		for cell_index in row.size():
			var cell: String = row[cell_index]
			if cell != " ":
				var unit_slot_id: String = battle_logic.commit_action(BattleActions.create_action("create_unit_slot")).get("id", "")
				unit_slot_layout[row_index][cell_index] = unit_slot_id
			else:
				new_row.push_back("")
	
	var _r := battle_logic.commit_action_item(BattleActions.wrap_in_batch(
		[BattleActions.create_action("attach_unit_slot_to_battlefield", {
				"battlefield_id": battlefield_id,
				"unit_slot_layout": unit_slot_layout,
		})],
		BattleActions.create_animation("unit_slot_layout_animate")
	))
	
	complete_intent()
