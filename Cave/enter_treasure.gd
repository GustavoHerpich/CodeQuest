class_name Enter_Treasure
extends Area2D

var changing_scene = false

## Métodos Privados

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter and not changing_scene:
		changing_scene = true
		SceneSwitcher.switch_scene("res://Cave/treasure.tscn") 

 
