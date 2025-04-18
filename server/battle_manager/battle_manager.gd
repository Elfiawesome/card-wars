class_name BattleManager extends Node

var network_bus: Server.NetworkBus
var _battles: Dictionary[String, BattleLogic] = {}

func create_battle() -> BattleLogic:
	var battle_id := generate_battle_id()
	var battle := BattleLogic.new(network_bus)
	add_child(battle)
	battle.name = battle_id
	_battles[battle_id] = battle
	return battle

func generate_battle_id() -> String: return UUID.v4()
