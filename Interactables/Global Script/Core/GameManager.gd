extends Node

var registered_methods := {}
var terminal: LuaConsole = LuaConsole.new()

func _ready() -> void:
	terminal.called_method.connect(method_called_callback)

func register_object(object: Node):
	var methods = object.get_method_list()
	
	for method in methods:
		var method_callable = Callable(object, method["name"]) 
		registered_methods[method["name"]] = method_callable
		terminal.bind_method(method["name"]) 
		continue 

func method_called_callback(method_name: String):
	var method_callable = registered_methods.get(method_name)
	
	if method_callable:
		method_callable.call() 
	else:
		print("Erro: método %s não registrado" % method_name)

func run_lua_script(lua_code: String):
	terminal.run_script(lua_code)
