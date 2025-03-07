extends Node

var registered_objects := {}

func register_object(object: Node):
	var object_name = object.name.to_lower()
	registered_objects[object_name] = object
	
	var methods = object.get_method_list()
	for method in methods:
		if method["name"].begins_with("_"): 
			continue 
		# Terminal.lua_console.bind_method(method["name"])

		print("Registrando método: %s em %s" % [method["name"], object_name])

func call_method(object_name: String, method_name: String, args: Array = []):
	var object = registered_objects.get(object_name.to_lower())
	if object and object.has_method(method_name):
		return object.callv(method_name, args)
	else:
		print("Erro: %s não tem o método %s" % [object_name, method_name])
