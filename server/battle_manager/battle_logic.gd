class_name BattleLogic extends Node

var network_bus: Server.NetworkBus
var connected_clients: Array = []
var intent_queue: Array[BattleIntent] = []
var current_intent: BattleIntent
var action_queue: Array[Dictionary] = []

func _init(network_bus_: Server.NetworkBus) -> void:
	network_bus = network_bus_


func _process(delta: float) -> void:
	if !intent_queue.is_empty():
		if current_intent == null:
			var intent: BattleIntent = intent_queue.pop_front() as BattleIntent
			current_intent = intent
			current_intent.run()
	if current_intent != null:
		if current_intent.is_finished:
			current_intent = null
	
	if !action_queue.is_empty():
		var action_item: Dictionary = action_queue.pop_front()
		handle_action_item(action_item)

func handle_action_item(item: Dictionary, parent_batch_id: int = -1) -> void:
	var block: String = item.get("Block", "")
	
	if block == "Batch":
		var animation: Dictionary = item.get("Animation", {})
		network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", ["BatchStart", animation])
		var list: Array = item.get("List", [])
		for sub_item: Dictionary in list:
			handle_action_item(sub_item)
		
		network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", ["BatchEnd"])
		
	elif block == "Action":
		var action_type: String = item.get("Type", "") as String
		var action_data: Dictionary= item.get("Data", {}) as Dictionary
		var recipients: Array= item.get("Recipients", []) as Array
		
		var battle_action_handler := BattleActionHandler.get_battle_action_handler(action_type)
		if !battle_action_handler: return
		
		var server_result_data := battle_action_handler.handle_as_server(self, action_data)
		if recipients.is_empty():
			# Tell everyone about this action
			network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", [
				"Action", action_type, action_data, server_result_data
			])
		else:
			# Tell only that person about this action
			network_bus.broadcast_specific_data(recipients, "BattleActionAssembler", [
				"Action", action_type, action_data, server_result_data
			])

func generate_player_id() -> String: return str(Time.get_ticks_usec())

func commit_action(action: Dictionary) -> void:
	action_queue.push_back(action)
func commit_intent(intent_type: String, intent_params: Dictionary = {}) -> void:
	var intent := BattleIntent.create(self, intent_type, intent_params)
	if intent: intent_queue.push_back(intent)


class Player:
	var id: String
	var player_id: String
