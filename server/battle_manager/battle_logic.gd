class_name BattleLogic extends Node

var network_bus: Server.NetworkBus
var connected_clients: Array = []
var action_sequencers: Array[ActionSequencer] = []

func _init(network_bus_: Server.NetworkBus) -> void:
	network_bus = network_bus_

func generate_player_id() -> String: return str(Time.get_ticks_usec())

func add_action_sequencer(action_sequencer: ActionSequencer) -> void:
	action_sequencers.push_back(action_sequencer)

class Player:
	var id: String
	var player_id: String
