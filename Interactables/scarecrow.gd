extends StaticBody2D
class_name Scarecrow

@onready var interactable: Interactable = $Interactable
@onready var sprite: Sprite2D = $Sprite

func _ready():
	interactable.interact = _open_terminal

func _open_terminal():
	print('bla')
