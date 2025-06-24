class_name Goblin
extends CharacterBody2D

var VARIABLE_WHEEL_SCENE = preload("res://Interactables/Components/WheelScene/variable_wheel_scene.tscn")
var has_interacted: bool = false

@onready var interactable: Interactable = $Interactable

## Private Methods

func _ready():
	add_to_group(GameConstants.GROUP_INTERACTABLE_OBJECTS)
	interactable.interact = _open_roulette

func _open_roulette():
	if has_interacted:
		return
	
	has_interacted = true
	
	var wheel_instance = VARIABLE_WHEEL_SCENE.instantiate()
	
	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player:
		wheel_instance.global_position = player.global_position + Vector2(250, 0)
	
	if SceneSwitcher.current_scene:
		SceneSwitcher.current_scene.add_child(wheel_instance)
	else:
		print("⚠️ ERRO: Cena atual não encontrada!")
	
func can_move() -> bool:
	return false
