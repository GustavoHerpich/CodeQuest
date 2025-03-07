extends StaticBody2D
class_name Scarecrow

@onready var interactable: Interactable = $Interactable
@onready var sprite: Sprite2D = $Sprite

var has_interacted: bool = false

var TerminalScene = preload("res://Interactables/Console/console.tscn") 

func _ready():
	interactable.interact = _open_terminal

func _open_terminal():
	if has_interacted:
		return
	
	has_interacted = true
	var terminal_instance = TerminalScene.instantiate()
	terminal_instance.global_position = global_position + Vector2(525, 50)  
	get_tree().current_scene.add_child(terminal_instance)
