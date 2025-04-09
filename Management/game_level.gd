class_name GameLevel
extends Node2D

func _ready() -> void:
	for node in get_children():
		if node.has_method("set_process"):
			node.set_process(false)
		if node.has_method("set_physics_process"):
			node.set_physics_process(false)
			
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
