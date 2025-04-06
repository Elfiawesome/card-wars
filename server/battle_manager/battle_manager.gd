class_name BattleManager extends Node

var network_bus: Server.NetworkBus

func create_battle() -> BattleLogic:
	var battle_id := generate_battle_id()
	var battle := BattleLogic.new(network_bus)
	add_child(battle)
	return battle

func generate_battle_id() -> String: return str(Time.get_ticks_usec())
