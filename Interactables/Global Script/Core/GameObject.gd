class_name GameObject
extends Node

func _ready():
	GameManager.register_object(get_parent())
