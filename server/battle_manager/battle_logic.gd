class_name BattleLogic extends Node

var network_bus: Server.NetworkBus
var connected_clients: Array = []
var intent_queue: Array[BattleIntent] = []
var current_intent: BattleIntent
var player_instance: Dictionary[String, PlayerInstance] = {}
var battlefields: Dictionary[String, Battlefield] = {}
var unit_slots: Dictionary[String, UnitSlot] = {}
var player_order: Array[String] = []

func _init(network_bus_: Server.NetworkBus) -> void:
	network_bus = network_bus_

func _process(delta: float) -> void:
	_handle_intent_queue()

func create_battlefield() -> String:
	var battlefield_id :=  generate_id()
	var battlefield := Battlefield.new(battlefield_id, self)
	battlefields[battlefield_id] = battlefield
	return battlefield_id
func get_battlefield(battlefield_id: String) -> Battlefield: return battlefields.get(battlefield_id)

func create_unit_slot() -> String:
	var unit_slot_id :=  generate_id()
	var unit_slot := UnitSlot.new(unit_slot_id, self)
	unit_slots[unit_slot_id] = unit_slot
	return unit_slot_id
func get_unit_slot(unit_slot_id: String) -> UnitSlot: return unit_slots.get(unit_slot_id)

func generate_id() -> String: return UUID.v4()

# Intent & Action Item
func _handle_intent_queue() -> void:
	if !intent_queue.is_empty():
		if current_intent == null:
			var intent: BattleIntent = intent_queue.pop_front() as BattleIntent
			current_intent = intent
			current_intent.run()
	if current_intent != null:
		if current_intent.is_finished:
			current_intent = null
func _handle_action_item(item: Dictionary, parent_batch_id: int = -1) -> Array:
	var action_results: Array = []
	var block := BattleIntent.get_action_item_block_type(item)
	
	if block == BattleIntent.ACTION_ITEM_BLOCK_TYPE.BATCH:
		var animation := BattleIntent.get_batch_animation(item)
		if animation:
			network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", ["BatchStart", animation])
		else:
			network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", ["BatchStart"])
		for sub_item: Dictionary in BattleIntent.get_batch_list(item):
			var action_result := _handle_action_item(sub_item)
			action_results.push_back(action_result)
		network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", ["BatchEnd"])
		
	elif block == BattleIntent.ACTION_ITEM_BLOCK_TYPE.ACTION:
		var action_type := BattleIntent.get_action_type(item)
		var action_data := BattleIntent.get_action_data(item)
		var recipients := BattleIntent.get_action_recipients(item)
		
		var battle_action_handler := BattleActionHandler.get_battle_action_handler(action_type)
		if battle_action_handler:
			var action_result := battle_action_handler.handle_as_server(self, action_data)
			action_results = [action_result]
			if recipients.is_empty():
				# Tell everyone about this action
				network_bus.broadcast_specific_data(connected_clients, "BattleActionAssembler", ["Action", action_type, action_data])
			else:
				# Tell only that person about this action
				network_bus.broadcast_specific_data(recipients, "BattleActionAssembler", ["Action", action_type, action_data])
	
	return action_results
func commit_action_item(action_item: Dictionary) -> Array:
	return _handle_action_item(action_item)
func commit_action(action: Dictionary) -> Dictionary:
	var result := _handle_action_item(action)
	if result.size() > 0: return result[0]
	return {}
func commit_intent(intent_type: String, intent_params: Dictionary = {}) -> void:
	var intent := BattleIntent.create(self, intent_type, intent_params)
	if intent: intent_queue.push_back(intent)

class Base:
	var battle_logic: BattleLogic
	var id: String
	
	func _init(id_: String, battle_logic_: BattleLogic) -> void:
		battle_logic = battle_logic_
		id = id_
class PlayerInstance extends Base:
	var client_id: String
class Battlefield extends Base:
	var unit_slots: Array[Array] = []
	var heroes: Array[String] = []
class UnitSlot extends Base:
	var battlefield_id: String
	var coords: Array[int] = []
