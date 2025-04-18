class_name BattleView extends CanvasLayer

var action_item_queue: Array[Dictionary] = []


func handle_action(action: Dictionary) -> void:
	action.get("Type")
	action.get("Data")

class Clip:
	pass
