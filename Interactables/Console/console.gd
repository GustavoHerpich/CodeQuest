class_name Console
extends Control

var lua_console: LuaConsole = LuaConsole.new()
const MyHighlighter = preload("res://Interactables/Global Script/CodeStyles/MyHighlighter.gd")
var dragging: bool = false
var drag_offset: Vector2

@onready var text_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/CodeEditor/TextEdit
@onready var message_container: MessageContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/MessagesContainer

## Private Methods

func _ready() -> void:
	var highlighter = MyHighlighter.new()
	text_edit.syntax_highlighter = highlighter
	GameManager.print_message.connect(_print_callback)
	GameManager.error_message.connect(_error_callback)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_in_terminal = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		queue_free()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_global_rect().has_point(event.position):
					dragging = true
					drag_offset = event.position - global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = event.position - drag_offset  
		
func _on_tree_exiting() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_in_terminal = false

	for obj in get_tree().get_nodes_in_group("Interactable Objects"):
		obj.has_interacted = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_execute_pressed() -> void:
	var lua_source = text_edit.text
	GameManager.run_lua_script(lua_source)
	
func _error_callback(message: String) -> void:
	message_container.add_error(message)

func _print_callback(message: String) -> void:
	message_container.add_info(message)
	
##
