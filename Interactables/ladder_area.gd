extends Area2D
class_name LadderArea

func _on_body_exited(body: CharacterBody2D) -> void:
	if body is BaseCharacter:
		if global_position.y > body.global_position.y:
			body.update_montain_state(true)
			
		if global_position.y < body.global_position.y:
			body.update_montain_state(false)
