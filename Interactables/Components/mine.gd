class_name Mine
extends StaticBody2D

@onready var interactable: Interactable = $Interactable

func _ready() -> void:
	interactable.interact = _call_cave

func _call_cave() -> void:
	SceneSwitcher.switch_scene("res://Cave/cave.tscn")
	
