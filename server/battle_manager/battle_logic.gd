class_name BattleLogic extends Node

var network_bus: Server.NetworkBus
var connected_clients: Array = []
var instruction_list: Array = []
var action_batch_queue: Array[Dictionary] = []

func _init(network_bus_: Server.NetworkBus) -> void:
	network_bus = network_bus_

func _process(delta: float) -> void:
	if !action_batch_queue.is_empty():
		var action_batch: Dictionary = action_batch_queue.pop_front()
		handle_action_item(action_batch)
		network_bus.broadcast_specific_data(connected_clients, "HandleActionBatch", [action_batch])

func generate_player_id() -> String: return str(Time.get_ticks_usec())

func commit_action_batch(action_batch: Dictionary) -> void:
	action_batch_queue.push_back(action_batch)

func handle_action_item(action_item: Dictionary) -> void:
	var type: String = action_item.get("Type", "")
	if type == "ActionBatch":
		var action_list: Array = action_item.get("ActionList", [])
		for item: Dictionary in action_list:
			handle_action_item(item)
	elif type == "Action":
		var action_type: String = action_item.get("ActionType", "")
		var action_data: Dictionary = action_item.get("ActionData", {})
		print("Server running: " + action_type)


class Player:
	var id: String
	var player_id: String
