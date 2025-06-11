class_name EnterTreasure
extends Area2D

var changing_scene = false

## Private Methods

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and not changing_scene:
		changing_scene = true
		set_deferred("monitoring", false)
		SceneSwitcher.switch_scene("res://Cave/TreasureScene/treasure.tscn", self)

##
