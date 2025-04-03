class_name DialogueArea
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is BaseCharacter:
		DialogueManager.show_example_dialogue_balloon(load("res://Dialogues/main.dialogue"), "start")
		return 


func _on_body_exited(_body: Node2D) -> void:
	pass
