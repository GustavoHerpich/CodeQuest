extends Node

signal print_message(message: String)
signal error_message(message: String)

enum GameState {
	PLAYING,
	BOOK_OPEN,
	CONSOLE_OPEN
}

var registered_methods: Dictionary = {}
var terminal: LuaConsole = LuaConsole.new()

var current_state: GameState = GameState.PLAYING

## --- Lifecycle ---

func _ready() -> void:
	terminal.print.connect(print)
	terminal.error.connect(error)
	terminal.called_method.connect(_method_called_callback)

## --- Internal Methods ---

func _get_method_argument_types(object: Object, method_name: String) -> Array:
	for method in object.get_method_list():
		if method["name"] == method_name:
			return method["args"].map(func(arg): return arg["type"])
	return []

func _method_called_callback(method_name: String, args: Array = []):
	var method_callable = registered_methods.get(method_name)
	if method_callable:
		method_callable.callv(args)
	else:
		error("Erro: método %s não registrado" % method_name)

func _update_cursor_visibility() -> void:
	var book_visible = BookManager.book_instance and BookManager.book_instance.get_node("Book").visible
	var console_visible := false

	for console in get_tree().get_nodes_in_group("Console Instances"):
		if is_instance_valid(console) and console.is_inside_tree() and console.visible:
			console_visible = true
			break

	var should_show_cursor = book_visible or console_visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if should_show_cursor else Input.MOUSE_MODE_CAPTURED)

#

## --- Public Interface ---

func print(msg: String) -> void:
	print_message.emit(msg)

func error(msg: String) -> void:
	error_message.emit(msg)

func register_object(object: Node):
	for method in object.get_method_list():
		var method_name = method["name"]
		var method_callable := Callable(object, method_name)
		registered_methods[method_name] = method_callable

		var arg_types := _get_method_argument_types(object, method_name)
		terminal.bind_method(method_callable, arg_types)

	for property in object.get_property_list():
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var var_name = property["name"]
			object.set_meta(var_name, object.get(var_name))

func run_lua_script(lua_code: String):
	terminal.run_script(lua_code)

func set_value_variable(object: Object, var_name: String, amount: Variant) -> void:
	if object.has_meta(var_name):
		var new_value = object.get_meta(var_name) + amount
		object.set_meta(var_name, new_value)
		object.set(var_name, new_value)
	else:
		error("Variável não encontrada: %s" % var_name)

func get_value_variable(object: Object, var_name: String):
	if object.has_meta(var_name):
		return object.get_meta(var_name)
	else:
		error("Variável não encontrada: %s" % var_name)
		return null

func update_mouse_visibility() -> void:
	_update_cursor_visibility()

#
