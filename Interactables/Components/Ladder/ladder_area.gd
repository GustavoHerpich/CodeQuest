class_name LadderArea
extends Area2D

func _on_body_exited(body: CharacterBody2D) -> void:
	if body is PlayerPawn:
		if global_position.y > body.global_position.y:
			body.update_montain_state(true)
			
		if global_position.y < body.global_position.y:
			body.update_montain_state(false)
