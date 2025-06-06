class_name Console
extends Control

const MyHighlighter = preload("res://Interactables/Global Script/CodeStyles/MyHighlighter.gd")
var lua_console: LuaConsole = LuaConsole.new()
var dragging: bool = false
var drag_offset: Vector2

@onready var text_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/CodeEditor/TextEdit
@onready var message_container: MessageContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/MessagesContainer
@onready var drag_area: Control = $Panel/MarginContainer/VBoxContainer/DragArea

## Private Methods

func _ready() -> void:
	var highlighter = MyHighlighter.new()
	text_edit.syntax_highlighter = highlighter
	GameManager.print_message.connect(_print_callback)
	GameManager.error_message.connect(_error_callback)
	
	GameManager.update_mouse_visibility()
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_in_terminal = true
		

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		self.visible = false
		queue_free()
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if drag_area.get_global_rect().has_point(get_global_mouse_position()):
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
		if obj is Terminal:
			obj.has_interacted = false
	
	GameManager.update_mouse_visibility()

func _on_execute_pressed() -> void:
	var lua_source = text_edit.text
	GameManager.run_lua_script(lua_source)
	
func _error_callback(message: String) -> void:
	message_container.add_error(message)

func _print_callback(message: String) -> void:
	message_container.add_info(message)
	
##
