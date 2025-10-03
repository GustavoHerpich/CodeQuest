class_name Console
extends Control

const CodeStyle = preload("res://Management/Global Script/CodeStyles/code_style.gd")

var lua_console: LuaConsole = LuaConsole.new()
var dragging: bool = false
var drag_offset := Vector2()
var command_history: Array[String] = []
var history_index := -1

@onready var text_edit: TextEdit = $Panel/MarginContainer/VBoxContainer/CodeEditor/TextEdit
@onready var message_container: MessageContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/MessagesContainer
@onready var drag_area: Control = $Panel/MarginContainer/VBoxContainer/DragArea

func _ready() -> void:
	add_to_group(GameConstants.GROUP_CONSOLE_INSTANCES)
	var highlighter = CodeStyle.new()
	highlighter.set_language("lua")
	text_edit.syntax_highlighter = highlighter

	GameManager.print_message.connect(_print_callback)
	GameManager.error_message.connect(_error_callback)
	GameManager.update_mouse_visibility()

	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player and "enter_terminal" in player:
		player.enter_terminal()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GameConstants.INPUT_EXIT):
		close()

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and drag_area.get_global_rect().has_point(get_global_mouse_position()):
				dragging = true
				drag_offset = event.position - global_position
			else:
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		global_position = event.position - drag_offset

	elif event is InputEventKey:
		match event.keycode:
			KEY_UP:
				_navigate_history(-1)
			KEY_DOWN:
				_navigate_history(1)

func _on_execute_pressed() -> void:
	var lua_source := text_edit.text
	command_history.append(lua_source)
	history_index = command_history.size()
	GameManager.run_lua_script(lua_source)

func _navigate_history(direction: int) -> void:
	history_index += direction
	history_index = clamp(history_index, 0, command_history.size() - 1)
	if history_index >= 0 and history_index < command_history.size():
		text_edit.text = command_history[history_index]
		text_edit.set_caret_column(text_edit.text.length())

func _error_callback(message: String) -> void:
	message_container.add_error(message)

func _print_callback(message: String) -> void:
	message_container.add_info(message)

func _on_tree_exiting() -> void:
	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player and "exit_terminal" in player:
		player.exit_terminal()

	for obj in get_tree().get_nodes_in_group(GameConstants.GROUP_INTERACTABLE_OBJECTS):
		if obj is Terminal:
			obj.has_interacted = false

	GameManager.update_mouse_visibility()

func close() -> void:
	self.visible = false
	queue_free()
