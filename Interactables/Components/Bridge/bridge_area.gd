class_name BridgeArea
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		if body.get_is_in_mountain() == false:
			return
		print(body)
		body.update_collision_layer_mask("in")
		
func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		body.update_collision_layer_mask("out")
