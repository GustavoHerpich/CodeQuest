extends Node
class_name GameObject

func _ready():
	GameManager.register_object(self)
