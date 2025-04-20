extends BattleIntent

func run() -> void:
	var battlefield_id: String = battle_logic.commit_action(BattleIntent.create_action("CreateBattlefield")).get("id", "")
	if !battlefield_id: return
	var unit_slot_layout: Array[Array] = [["#","#","#"],[" ","#"," "]]
	
	for row_index in unit_slot_layout.size():
		var row := unit_slot_layout[row_index]
		var new_row: Array[String] = []
		for cell_index in row.size():
			var cell: String = row[cell_index]
			if cell != " ":
				var unit_slot_id: String = battle_logic.commit_action(BattleIntent.create_action("CreateUnitSlot")).get("id", "")
				unit_slot_layout[row_index][cell_index] = unit_slot_id
			else:
				new_row.push_back("")
	
	var _r := battle_logic.commit_action_item(BattleIntent.wrap_in_batch(
		[BattleIntent.create_action("AttachUnitSlotToBattlefield", {
				"battlefield_id": battlefield_id,
				"unit_slot_layout": unit_slot_layout,
		})],
		BattleIntent.create_animation("UnitSlotLayoutAnimate")
	))
	
	complete_intent()
