class_name	CodeStyle
extends CodeHighlighter

func _init():
	number_color = Color(0.8, 0.6, 0)  # Amarelo-alaranjado para números
	function_color = Color(0.4, 0.6, 1)  # Azul-claro para funções
	member_variable_color = Color(0.6, 0.8, 1)  # Azul mais claro para variáveis de membro
	symbol_color = Color(1, 0.5, 0)  # Laranja para símbolos
 
	var lua_keywords = [
		"function", "local", "if", "then", "else", "elseif", "end",
		"for", "while", "repeat", "until", "return", "break",
		"do", "not", "and", "or", "true", "false", "nil", "in"
	]
	for keyword in lua_keywords:
		add_keyword_color(keyword, Color(1, 0.4, 0.6)) # Vermelho mais suave, puxando para o rosa

	# Strings → Verde
	add_color_region("\"", "\"", Color(0.6, 1, 0.6), false) 

	# Comentários (`--`) → Cinza
	add_color_region("--", "", Color(0.5, 0.5, 0.5), true)
