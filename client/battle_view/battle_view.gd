class_name BattleView extends CanvasLayer

@onready var debug_label: Label = $Panel/DebugLabel

var network_connection: GameSession.NetworkConnectionBase

var root_action_resolver: BattleActionBatchResolver = BattleActionBatchResolver.new()

var battlefield_containers: Dictionary[String, BattlefieldContainer] = {}
var unit_slot_containers: Dictionary[String, UnitSlotContainer] = {}

func _ready() -> void:
	add_child(root_action_resolver)
	root_action_resolver.name = "RootActionResolver"
	root_action_resolver.process_action.connect(_handle_action)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			network_connection.send_data("battle_response", ["end_turn"])

func create_battlefield_container(battlefield_id: String) -> BattlefieldContainer:
	var scene := preload("res://client/battle_view/battlefield_container.tscn")
	var battlefield_container := scene.instantiate()
	battlefield_container.id = battlefield_id
	battlefield_containers[battlefield_id] = battlefield_container
	return battlefield_container
func create_unit_slot_container(unit_slot_id: String) -> UnitSlotContainer:
	var scene := preload("res://client/battle_view/unit_slot_container.tscn")
	var unit_slot_container := scene.instantiate()
	unit_slot_container.id = unit_slot_id
	unit_slot_containers[unit_slot_id] = unit_slot_container
	return unit_slot_container

func _handle_action(action: Dictionary) -> void:
	var type := BattleActions.get_action_type(action)
	var data := BattleActions.get_action_data(action)
	var handler := BattleActionHandler.get_battle_action_handler(type)
	if handler:
		print("Processing Action: %s - %s" % [type, data])
		handler.handle_as_client(self, data)
	else:
		print("Processing and [INVALID!] Action: %s - %s" % [type, data])
