extends Node

signal print_message(message: String)
signal error_message(message: String)

var registered_methods := {}
var terminal: LuaConsole = LuaConsole.new()

## Private Methods

func _ready() -> void:
	terminal.print.connect(print)
	terminal.error.connect(error)
	terminal.called_method.connect(_method_called_callback)
	
func _get_method_argument_types(object: Object, method_name: String) -> Array:
	var argument_types := []
	var method_list = object.get_method_list()
	for method in method_list:
		if method["name"] == method_name:
			argument_types = method["args"].map(func(arg): return arg["type"])
			break
	return argument_types

func _method_called_callback(method_name: String, args: Array = []):
	var method_callable = registered_methods.get(method_name)
	if method_callable:
		method_callable.callv(args)
	else:
		error("Erro: método %s não registrado" % method_name)

##

## Public Methods

func print(msg: String) -> void:
	print_message.emit(msg)

func error(msg: String) -> void:
	error_message.emit(msg)
	
func register_object(object: Node):
	var methods = object.get_method_list()
	for method in methods:
		var method_callable = Callable(object, method["name"])
		registered_methods[method["name"]] = method_callable
		var arg_types := _get_method_argument_types(object, method["name"])
		terminal.bind_method(method_callable, arg_types)
		
	for property in object.get_property_list():
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var var_name = property["name"]
			var var_value = object.get(var_name)
			object.set_meta(var_name, var_value)
			
func run_lua_script(lua_code: String):
	terminal.run_script(lua_code)
	
func set_value_variable(object: Object, var_name: String, amount: Variant) -> void:
	if object.has_meta(var_name):
		var new_value = object.get_meta(var_name) + amount
		object.set_meta(var_name, new_value)
		object.set(var_name, new_value)
	else:
		error("Variável não encontrada: %s " % var_name)
		
func get_value_variable(object: Object, var_name: String):
	if object.has_meta(var_name):
		return object.get_meta(var_name)
	else:
		error("Variável não encontrada: %s " % var_name)
		return null

##
