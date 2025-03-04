extends Area2D
class_name BridgeArea

func _on_body_entered(_body: Node2D) -> void:
	print(_body)
	if _body is BaseCharacter:
		if _body.get_is_in_mountain() == false:
			return
		_body.update_collision_layer_mask("in")
		
func _on_body_exited(_body: Node2D) -> void:
	if _body is BaseCharacter:
		_body.updatae_collision_layer_mask("out")
