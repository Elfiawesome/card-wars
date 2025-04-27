class_name BattlefieldContainer extends Control

var id: String

var grid: Dictionary[Vector2i, UnitSlotContainer]

var scene := preload("res://client/battle_view/unit_slot_container.tscn")

func _ready() -> void:
	pass
