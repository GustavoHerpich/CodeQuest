class_name PuzzlePlate
extends Node2D

static var plate_values: Array = []

const SYMBOLS := ["⍟", "◆", "◎", "◇", "✦", "▓", "░", "█"]

@onready var game_object_register := GameObject.new()
@onready var label: Label = $Label

func _ready() -> void:
	add_child(game_object_register)
	randomize()

	if PuzzlePlate.plate_values.is_empty():
		var plates := _get_all_plates()
		for _i in plates:
			PuzzlePlate.plate_values.append(randi_range(1, 99))

	label.text = SYMBOLS.pick_random()

func _reset_all() -> void:
	PuzzlePlate.plate_values.clear()
	var plates := _get_all_plates()
	for p in plates:
		p.label.text = SYMBOLS.pick_random()

## Retorna todas as instâncias de PuzzlePlate dentro do mesmo pai
func _get_all_plates() -> Array:
	var plates: Array = []
	var parent := get_parent()
	if parent:
		for c in parent.get_children():
			if c is PuzzlePlate:
				plates.append(c)
	return plates

## Methods that interact with the console

func getPlateValues() -> Array:
	return PuzzlePlate.plate_values.duplicate()

func solvePlate(order: Array) -> bool:
	if typeof(order) != TYPE_ARRAY:
		GameManager.error("Entrada inválida.")
		return false

	var expected := PuzzlePlate.plate_values.duplicate()
	expected.sort()

	var candidate := order.duplicate()
	candidate.sort()

	if candidate != expected:
		GameManager.error("❌ Ordem incorreta.")
		return false

	var plates := _get_all_plates()
	var n = min(expected.size(), plates.size())
	for i in range(n):
		plates[i].label.text = str(expected[i])

	GameManager.print("✅ Ordem correta da lista!")
	return true
