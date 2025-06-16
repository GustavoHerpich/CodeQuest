class_name Goblin
extends CharacterBody2D

var has_interacted: bool = false

@onready var interactable: Interactable = $Interactable

## Private Methods

func _ready():
	add_to_group(GameConstants.GROUP_INTERACTABLE_OBJECTS)
	interactable.interact = _open_roulette

func _open_roulette():
	print("bla")

func can_move() -> bool:
	return false
