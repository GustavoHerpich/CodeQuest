class_name DecorationComponent
extends Node2D

@export_category("Variables")
@export var texture_list: Array[String]

func _ready() -> void:
	for _children in get_children():
		if _children is Sprite2D:
			_children.texture = load(
				texture_list.pick_random()
			)
