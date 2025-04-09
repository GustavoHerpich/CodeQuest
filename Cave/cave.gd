class_name Cave
extends Node2D

@onready var interactable: Interactable = $Interactable
@onready var cave_music: AudioStreamPlayer2D = $Sounds/CaveMusic

## Private Methods

func _ready() -> void:
	interactable.interact = _call_game_level
	cave_music.play()

func _call_game_level() -> void:
	SceneSwitcher.switch_scene("res://Management/game_level.tscn", null, "SpawnPoint2")

##
