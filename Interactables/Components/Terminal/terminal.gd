class_name Terminal
extends StaticBody2D

var has_interacted: bool = false
var TerminalScene = preload("res://Interactables/Console/console.tscn") 

@onready var interactable: Interactable = $Interactable
@onready var sprite: Sprite2D = $Sprite
	
func _ready():
	interactable.interact = _open_terminal

func _open_terminal():
	if has_interacted:
		return
	
	has_interacted = true
	
	var terminal_instance = TerminalScene.instantiate()

	if SceneSwitcher.current_scene:
		SceneSwitcher.current_scene.add_child(terminal_instance)
	else:
		print("⚠️ ERRO: Cena atual não encontrada!")

	terminal_instance.get_child(0).global_position += Vector2(100, 100)  
