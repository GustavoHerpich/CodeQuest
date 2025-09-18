class_name Maze
extends Node2D

@onready var bridget_emerging: TileMapLayer = $BridgetEmerging

func _ready() -> void:
	$MazePuzzle.connect("puzzle_solved", Callable(self, "_on_puzzle_solved"))
	bridget_emerging.modulate = Color(1, 1, 1, 0)
	bridget_emerging.hide()

func _on_puzzle_solved() -> void:
	GameManager.print("⏳ A ponte está surgindo... aguarde 5 segundos.")

	await get_tree().create_timer(5.0).timeout

	bridget_emerging.show()
	var tween := get_tree().create_tween()
	tween.tween_property(bridget_emerging, "modulate", Color(1, 1, 1, 1), 3.0)

	GameManager.print("🌉 A ponte surgiu! Agora você pode atravessar.")
