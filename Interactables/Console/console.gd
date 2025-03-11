class_name Console
extends Control

var terminal: LuaConsole = LuaConsole.new()
@onready var text_edit: TextEdit = $VBoxContainer/CodeEditor/TextEdit

## Private Methods

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_in_terminal = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		queue_free() 
		
func _on_tree_exiting() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_in_terminal = false

	var interactableObjects = get_tree().get_nodes_in_group("Interactable Objects")  
	if interactableObjects:
		interactableObjects[0].has_interacted = false
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_button_pressed() -> void:
	var lua_source = text_edit.text
	GameManager.run_lua_script(lua_source)

##
