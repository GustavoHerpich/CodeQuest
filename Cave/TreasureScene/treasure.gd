class_name Treasure
extends Node2D

@onready var interactable: Interactable = $Interactable

## Private Methods

func _ready() -> void:
	interactable.interact = _call_cave

func _call_cave() -> void:
	SceneSwitcher.switch_scene("res://Cave/cave.tscn", null, "SpawnPoint2")

##
