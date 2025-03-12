class_name BridgeFinalArea 
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		body.update_collision_layer_mask("in")
