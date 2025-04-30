class_name BattleLogic extends Node

var id: String
var network_bus: Server.NetworkBus
var connected_clients: Array = []
var client_to_player_instance: Dictionary[String, String] = {}

var intent_queue: Array[BattleIntent] = []
var current_intent: BattleIntent

var global_event_bus: EventBus = EventBus.new()

var player_instance: Dictionary[String, PlayerInstance] = {}
var player_response_limited: bool = false
var allowed_player_responses: Array[String] = []

var battlefields: Dictionary[String, Battlefield] = {}
var unit_slots: Dictionary[String, UnitSlot] = {}

enum Phase { None = 0, Setup, Attacking, Resolve }
var player_order: Array[String] = []
var current_turn: int = 0
var current_phase: Phase = Phase.None

func _init(network_bus_: Server.NetworkBus) -> void:
	network_bus = network_bus_

func _process(_delta: float) -> void:
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

func _handle_response(client_id: String, response_data: Array) -> void:
	var player_instance_id: String = client_to_player_instance.get(client_id, "")
	if player_instance_id == "": return
	if !(player_instance_id in player_instance): return
	var player: PlayerInstance = player_instance[player_instance_id]
	if response_data.size() < 1: return
	var response_type :String = response_data[0]
	
	# Handlers without limit response
	match response_type:
		"do_somehting": pass
	
	# Handlers with limit response
	if player_response_limited:
		if !(player_instance_id in allowed_player_responses): return
		match response_type:
			"end_turn":
				commit_intent("advance_turn")

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
func _handle_action_item(item: Dictionary) -> Array:
	var action_results: Array = []
	var block := BattleActions.get_item_block_type(item)
	if block == BattleActions.BLOCK_TYPE.BATCH:
		var animation := BattleActions.get_batch_animation(item)
		if animation:
			network_bus.broadcast_specific_data(connected_clients, "battle_action_assembler", [BattleActions.BATCH_START_CODE, animation])
		else:
			network_bus.broadcast_specific_data(connected_clients, "battle_action_assembler", [BattleActions.BATCH_START_CODE])
		for sub_item: Dictionary in BattleActions.get_batch_list(item):
			var action_result := _handle_action_item(sub_item)
			action_results.push_back(action_result)
		network_bus.broadcast_specific_data(connected_clients, "battle_action_assembler", [BattleActions.BATCH_END_CODE])
		
	elif block == BattleActions.BLOCK_TYPE.ACTION:
		var action_type := BattleActions.get_action_type(item)
		var action_data := BattleActions.get_action_data(item)
		var recipients := BattleActions.get_action_recipients(item)
		
		var battle_action_handler := BattleActionHandler.get_battle_action_handler(action_type)
		if battle_action_handler:
			var action_result := battle_action_handler.handle_as_server(self, action_data)
			action_results = [action_result]
			if recipients.is_empty():
				# Tell everyone about this action
				network_bus.broadcast_specific_data(connected_clients, "battle_action_assembler", [BattleActions.ACTION_CODE, action_type, action_data])
			else:
				# Tell only that person about this action
				network_bus.broadcast_specific_data(recipients, "battle_action_assembler", [BattleActions.ACTION_CODE, action_type, action_data])
	
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
	var unit_slots := GridArray.new()
	var heroes: Array[String] = []

class UnitSlot extends Base:
	var battlefield_id: String
	var coords: Vector2i = Vector2i.ZERO
class Unit extends Base:
	pass
class Hero extends Base:
	pass
class Ability:
	pass

class EventBus:
	var _subscriptions: Dictionary[String, Array] = {}
	func subscribe(event_type: String, callable: Callable) -> void:
		if !_subscriptions.has(event_type):
			_subscriptions[event_type] = []
		var subs: Array = _subscriptions[event_type]
		# Avoid duplicate subscriptions
		for sub: Callable in subs:
			if sub == callable:
				print("Tried to subscribe the same callable to the same event")
				return
		subs.push_back(callable)
	
	func unsubscribe(event_type: String, callable: Callable) -> void:
		if _subscriptions.has(event_type):
			var subs: Array = _subscriptions[event_type]
			if callable in subs:
				subs.erase(callable)
	
	func publish(event_type: String, event_data: Dictionary) -> void:
		if _subscriptions.has(event_type):
			var subs: Array = _subscriptions[event_type]
			for sub: Callable in subs:
				if sub.is_valid():
					sub.call(event_data)
