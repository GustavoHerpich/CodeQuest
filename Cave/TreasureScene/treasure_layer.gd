class_name TreasureLayer
extends Node2D

const DOOR_VALUES: Array = [26, 13, 17]

@onready var doors: Array = [$Door1, $Door2, $Door3]
@onready var door_1: Node2D = $Door1
@onready var game_object_register = GameObject.new()
@onready var door_open: AudioStreamPlayer2D = $"../Sounds/DoorOpen"

## Private Methods

func _ready() -> void:
	add_child(game_object_register)

##

## Methods that interact with the console

func getDoorValues() -> Array:
	return DOOR_VALUES.duplicate()

func showPassword(door_value: int) -> void:
	if door_value in DOOR_VALUES and door_value % 2 == 0:
		GameManager.print("⚔️ Porta correta! Senha revelada: " + str(door_value))
	else:
		GameManager.error("⛔ Valor incorreto, tente novamente.")

func openDoor(password: int) -> void:
	var correct_password: int = DOOR_VALUES[0] * 3
	if password == correct_password:
		door_1.set_collision_layer_value(1, false)
		var anim_player: AnimationPlayer = door_1.get_node("AnimationPlayer")
		if anim_player:
			if anim_player.has_animation("open"):	 
				anim_player.play("open")
				door_open.play()
				GameManager.print("🚪 A porta está abrindo!")

	else:
		GameManager.error("🔒 A senha está incorreta. Tente novamente!")

##
