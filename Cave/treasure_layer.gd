class_name TreasureLayer
extends Node2D

@onready var layer: TileMapLayer = $Layer
@onready var doors: Array = [$Door1, $Door2, $Door3]
@onready var torches: Array = [
	{"light": $"../Iluminasion/Torch7", "torch": $"../Torches/Torch7"},
	{"light": $"../Iluminasion/Torch8", "torch": $"../Torches/Torch8"},
	{"light": $"../Iluminasion/Torch9", "torch": $"../Torches/Torch9"},
	{"light": $"../Iluminasion/Torch10", "torch": $"../Torches/Torch10"}
]

const DOOR_VALUES: Array = [13, 26, 17]

@onready var game_object_register := GameObject.new()

func _ready() -> void:
	add_child(game_object_register)

## Métodos Privados

func _remove_torches() -> void:
	for torch_data in torches:
		torch_data["light"].visible = false
		torch_data["torch"].visible = false
		torch_data["torch"].set_collision_layer_value(1, false)

func _change_ports_state(estado: bool) -> void:
	for door in doors:
		door.visible = estado
		door.set_collision_layer_value(1, estado)

## Métodos Públicos

func getDoorValues() -> Array:
	return DOOR_VALUES.duplicate()

func showPassword(door_value: int) -> void:
	if door_value in DOOR_VALUES and door_value % 2 == 0:
		GameManager.print("⚔️ Porta correta! Senha revelada: " + str(door_value * 3))
	else:
		GameManager.error("⛔ Valor incorreto, tente novamente.")

func openDoor(password: int) -> void:
	var correct_password: int = DOOR_VALUES[1] * 3
	if password == correct_password:
		GameManager.print("🔓 As portas se abrem, para revelar um tesouro escondido!")
		_change_ports_state(false)
		layer.visible = false
		layer.collision_enabled = false
		_remove_torches()
	else:
		GameManager.error("🔒 A senha está incorreta. Tente novamente!")
