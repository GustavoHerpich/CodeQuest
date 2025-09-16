extends Node

## Classe global que gerencia a integração com o console Lua, manipulação
## de variáveis de objetos em tempo de execução e controle da visibilidade do cursor.
##
## Esta classe é registrada como Autoload (singleton) e possui as seguintes responsabilidades:
## - Registrar objetos e seus métodos/propriedades públicos para acesso via console Lua.
## - Gerenciar execução de scripts Lua e emissão de mensagens de console.
## - Controlar visibilidade do cursor com base no estado do Livro de Ajuda ou do Console.
## - Fornecer métodos utilitários para leitura e escrita de variáveis de objetos.
##
## O `registered_methods` mantém um mapeamento de métodos acessíveis via Lua,
## enquanto o `terminal` representa a instância do console Lua do jogo.

## Sinais emitidos pelo console Lua.
##
## - `print_message(message)`: emitido ao imprimir uma mensagem.
## - `error_message(message)`: emitido ao ocorrer um erro.
signal print_message(message: String)
signal error_message(message: String)

## Estados do jogo, usados para controle de interação.
enum GameState {
	PLAYING,      ## Estado normal de jogo.
	BOOK_OPEN,    ## Estado em que o Livro de Ajuda está aberto.
	CONSOLE_OPEN  ## Estado em que o Console Lua está aberto.
}

var registered_methods: Dictionary = {}
var terminal: LuaConsole = LuaConsole.new()
var current_state: GameState = GameState.PLAYING

## Inicializa o nó e conecta sinais do console.
func _ready() -> void:
	terminal.print.connect(print)
	terminal.error.connect(error)
	terminal.called_method.connect(_method_called_callback)

# ----------------------------
# Métodos Privados
# ----------------------------

## Retorna os tipos dos argumentos de um método de um objeto.
##
## - `object`: objeto a ser inspecionado.
## - `method_name`: nome do método.
func _get_method_argument_types(object: Object, method_name: String) -> Array:
	for method in object.get_method_list():
		if method["name"] == method_name:
			return method["args"].map(func(arg): return arg["type"])
	return []

## Callback chamado quando o console Lua invoca um método registrado.
##
## - `method_name`: nome do método chamado.
## - `args`: lista de argumentos passados.
func _method_called_callback(method_name: String, args: Array = []):
	var method_callable = registered_methods.get(method_name)
	if method_callable:
		method_callable.callv(args)
	else:
		error("Erro: método %s não registrado" % method_name)

## Atualiza a visibilidade do cursor com base no estado do Livro e do Console.
func _update_cursor_visibility() -> void:
	var book_visible = BookManager.book_instance and BookManager.book_instance.get_node("Book").visible
	var console_visible := false

	for console in get_tree().get_nodes_in_group(GameConstants.GROUP_CONSOLE_INSTANCES):
		if is_instance_valid(console) and console.is_inside_tree() and console.visible:
			console_visible = true
			break

	var should_show_cursor = book_visible or console_visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if should_show_cursor else Input.MOUSE_MODE_CAPTURED)

## Registra apenas os métodos "públicos" do objeto no terminal Lua.
##
## - Métodos que contêm "_" ou começam com "get"/"set" são ignorados.
## - Métodos padrão do Godot como _ready, _process e _physics_process são ignorados.
func _register_methods(object: Node):
	for method in object.get_method_list():
		var method_name = method["name"]

		# Ignora métodos que contenham "_" ou callbacks padrão
		if "_" in method_name:
			continue
		if method_name in ["_ready", "_process", "_physics_process"]:
			continue
		# Ignora getters e setters
		if method_name.begins_with("get") or method_name.begins_with("set"):
			continue
		
		var method_callable := Callable(object, method_name)
		registered_methods[method_name] = method_callable

		var arg_types := _get_method_argument_types(object, method_name)
		terminal.bind_method(method_callable, arg_types)

## Registra as propriedades do objeto para permitir manipulação via terminal.
##
## - Propriedades com `PROPERTY_USAGE_SCRIPT_VARIABLE` são armazenadas como metadata.
func _register_properties(object: Node):
	for property in object.get_property_list():
		if property["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var var_name = property["name"]
			object.set_meta(var_name, object.get(var_name))
			
# ----------------------------
# Métodos Públicos
# ----------------------------

## Emite uma mensagem de console.
func print(msg: Variant) -> void:
	print_message.emit(str(msg))

## Emite uma mensagem de erro no console.
func error(msg: Variant) -> void:
	error_message.emit(str(msg))

## Registra métodos e propriedades de um objeto para uso no terminal Lua.
##
## - `object`: objeto cujos métodos e propriedades serão registrados.
func register_object(object: Node):
	_register_methods(object)
	_register_properties(object)

## Executa um script Lua no console.
func run_lua_script(lua_code: String):
	terminal.run_script(lua_code)

## Define o valor de uma variável do objeto e atualiza a metadata.
##
## - `object`: objeto alvo.
## - `var_name`: nome da variável.
## - `amount`: valor a ser somado à variável.
func set_value_variable(object: Object, var_name: String, amount: Variant) -> void:
	if object.has_meta(var_name):
		var new_value = object.get_meta(var_name) + amount
		object.set_meta(var_name, new_value)
		object.set(var_name, new_value)
	else:
		error("Variável não encontrada: %s" % var_name)

## Retorna o valor de uma variável do objeto.
##
## - `object`: objeto alvo.
## - `var_name`: nome da variável.
func get_value_variable(object: Object, var_name: String):
	if object.has_meta(var_name):
		return object.get_meta(var_name)
	else:
		error("Variável não encontrada: %s" % var_name)
		return null

## Atualiza a visibilidade do cursor do mouse.
func update_mouse_visibility() -> void:
	_update_cursor_visibility()
