class_name CodeStyle
extends CodeHighlighter

# Estilo por linguagem
const LANGUAGE_KEYWORDS = {
	"lua": [
		"function", "local", "if", "then", "else", "elseif", "end",
		"for", "while", "repeat", "until", "return", "break",
		"do", "not", "and", "or", "true", "false", "nil", "in"
	],
	"gdscript": [
		"func", "var", "if", "else", "elif", "match", "for", "while",
		"class", "extends", "return", "pass", "break", "continue",
		"true", "false", "null", "in", "and", "or", "not"
	]
}

var current_language := "lua"
var custom_identifiers: Array[String] = []

func _init(language: String = "lua"):
	set_language(language)

# Configurações de cores 
func apply_common_colors() -> void:
	number_color = Color(0.8, 0.6, 0)               # Amarelo-alaranjado
	function_color = Color(0.4, 0.6, 1)             # Azul-claro
	member_variable_color = Color(0.6, 0.8, 1)      # Azul mais claro
	symbol_color = Color(1, 0.5, 0)                 # Laranja

	# Strings → Verde
	add_color_region("\"", "\"", Color(0.6, 1, 0.6), false)

	# Comentários de Lua e GDScript
	add_color_region("--", "", Color(0.5, 0.5, 0.5), true) # Lua
	add_color_region("#", "", Color(0.5, 0.5, 0.5), true)  # GDScript

# === DEFINIR LINGUAGEM ===
func set_language(lang: String) -> void:
	if not LANGUAGE_KEYWORDS.has(lang):
		push_error("Language not supported: %s" % lang)
		return
	
	current_language = lang
	clear_all_highlights()
	apply_common_colors()

	for keyword in LANGUAGE_KEYWORDS[lang]:
		add_keyword_color(keyword, Color(1, 0.4, 0.6))  # Rosa-vermelho suave

	for id in custom_identifiers:
		add_keyword_color(id, Color(0.9, 0.9, 0.4))  # Amarelo-claro

# Variáveis definidas pelo Usuário
func highlight_custom_identifiers(identifiers: Array[String]) -> void:
	custom_identifiers = identifiers.duplicate()
	
	for id in custom_identifiers:
		add_keyword_color(id, Color(0.9, 0.9, 0.4))  # Amarelo-claro

# Utils
func clear_all_highlights() -> void:
	clear_keyword_colors()
	clear_color_regions()
