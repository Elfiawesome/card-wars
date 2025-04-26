class_name BattlefieldContainer extends Control

var grid: Array[Array] = []

func _ready() -> void:
	child_entered_tree.connect(_on_child_entered)

func _on_child_entered(node: Node) -> void:
	pass
