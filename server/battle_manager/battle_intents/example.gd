extends BattleIntent

func run() -> void:
	var batch := create_batch(create_animation("Attack"))
	add_batch_action(batch, create_action("Action1"))
	
	var sub_batch := create_batch()
	add_batch_action(sub_batch, create_action("SubAct1"))
	add_batch_action(sub_batch, create_action("SubAct2"))
	add_batch_action(sub_batch, create_action("SubAct2", {}, [1,2,3]))
	add_batch_action(batch, sub_batch)
	
	add_batch_action(batch, create_action("Action1"))
	
	battle_logic.commit_action(batch)
