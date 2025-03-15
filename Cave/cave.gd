class_name Cave
extends Node2D

@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	interactable.interact = _call_game_level

func _call_game_level() -> void:
	SceneSwitcher.switch_scene("res://Management/game_level.tscn")
