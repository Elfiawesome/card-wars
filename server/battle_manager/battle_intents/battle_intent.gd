class_name BattleIntent extends RefCounted

static var REGISTRY := RegistrySimple.new()

var data: Dictionary = {}
var battle_logic: BattleLogic
var is_finished: bool

static func register() -> void:
	REGISTRY.register_all_objects_in_folder("res://server/battle_manager/battle_intents/")

static func create(battle_logic_: BattleLogic, intent_type: String, intent_data: Dictionary) -> BattleIntent:
	var script: GDScript = REGISTRY.get_object(intent_type)
	if script:
		var intent: BattleIntent = script.new() as BattleIntent
		intent.battle_logic = battle_logic_
		intent.data = intent_data
		return intent
	return

func run() -> void:
	pass
func callback(_callback_data: Dictionary) -> void:
	# Run when the client sends back any input to continue
	pass
func request_client_input() -> void:
	# Incomplete TODO: This is whern the intent requires client input, so we need to ask the client about the input
	# Then we will need to wait (need timer also) until the input is completed before we continue (we continue via callback?) Its a bit messy here
	pass
func complete_intent() -> void:
	is_finished = true
