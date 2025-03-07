extends Control
class_name Console

@onready var text_edit: TextEdit = $VBoxContainer/CodeEditor/TextEdit
@onready var lua_console: LuaConsole = $Control/LuaConsole

func _ready() -> void:
	# lua_console.called_method.connect(method_called_callback)
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

func method_called_callback(method_name, args):
	if args.size() > 0:
		var object_name = args[0]
		var method_args = args.slice(1, args.size())
		GameManager.call_method(object_name, method_name, method_args)

func _on_button_pressed() -> void:
	var lua_source = text_edit.text
	lua_console.run_script(lua_source) 
