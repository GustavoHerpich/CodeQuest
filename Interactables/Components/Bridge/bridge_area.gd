class_name BridgeArea
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is BaseCharacter:
		body.update_collision_layer_mask("in")
		
func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		body.update_collision_layer_mask("out")
