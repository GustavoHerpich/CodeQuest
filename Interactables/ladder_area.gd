extends Area2D
class_name LadderArea

func _on_body_exited(_body: Node2D) -> void:
	if _body is BaseCharacter:
		if global_position.y > _body.global_position.y:
			_body.update_montain_state(true)
			
		if global_position.y < _body.global_position.y:
			_body.update_montain_state(false)
