## Classe responsável por exibir o Livro de Ajuda no jogo.
##
## O Livro contém seções e páginas que podem ser navegadas pelo jogador,
## incluindo explicações sobre funções, dicas de programação e exemplos práticos.
## Ele também pode ser arrastado pela tela e possui efeito sonoro ao virar páginas.
class_name Book
extends CanvasLayer
 
var sections := {
	"funcoes_objetos": [],
	"como_programar": [],
	"inicio": []
}

var current_page := 0
var pages: Array = []
var dragging := false
var drag_offset := Vector2.ZERO

@onready var title: Label = $Book/Title
@onready var content_text: RichTextLabel = $Book/Content1
@onready var content_text_2: RichTextLabel = $Book/Content2
@onready var book: Control = $Book
@onready var drag_area: Control = $Book/DragArea
@onready var turn_page: AudioStreamPlayer = $TurnPage

## Inicialização do Livro de Ajuda.
func _ready() -> void:
	_load_pages()
	_flatten_pages()
	_render_page()


## Carrega as páginas iniciais do livro.
func _load_pages() -> void:
	add_page(
		"inicio",
		"📘 Bem-vindo ao Livro de Ajuda",
		"[center][b]Bem-vindo, aventureiro![/b][/center]\n\nAqui você encontrará tudo que precisa para resolver os desafios.\n\nUse as setas abaixo para navegar pelas páginas.",
		"[center]\n[b]📖 Dica:[/b] Preste atenção nos nomes das funções e exemplos.\nEles irão te ajudar a aprender programação de forma divertida![/center]"
	)

	add_page(
		"funcoes_objetos",
		"🧩 Funções dos Objetos",
		"[b]🔧 Ponte:[/b]\n[code]moveBridge(direction)[/code]\nDireções possíveis: 'up', 'down', 'left', 'right'\n\nExemplo:\n[code]moveBridge(\"down\")[/code]"
	)

	add_page(
		"como_programar",
		"📚 Como Programar em Lua",
		"[b]🧠 Funções:[/b]\n[code]function minha_funcao(param)\n  print(param)\nend\n\nminha_funcao(\"Olá\")[/code]\n\n[b]💡 Dica:[/b] Combine estruturas para resolver os desafios do jogo!"
	)

## Reorganiza todas as páginas em uma lista única.
func _flatten_pages() -> void:
	pages.clear()
	var ordered_keys := ["inicio", "funcoes_objetos", "como_programar", "fim_da_jornada"]
	for key in ordered_keys:
		if sections.has(key):
			pages += sections[key]
	current_page = 0

## Retorna `true` se houver uma próxima página disponível.
func has_next_page() -> bool:
	return current_page < pages.size() - 1

## Retorna `true` se houver uma página anterior disponível.
func has_previous_page() -> bool:
	return current_page > 0

## Renderiza a página atual na tela.
func _render_page() -> void:
	if current_page >= 0 and current_page < pages.size():
		var page = pages[current_page]
		title.text = page["title"]
		content_text.text = page["content1"]
		content_text_2.text = page["content2"]

## Avança para a próxima página, se existir.
func _next_page() -> void:
	if has_next_page():
		current_page += 1
		turn_page.play()
		_render_page()

## Volta para a página anterior, se existir.
func _previous_page() -> void:
	if has_previous_page():
		current_page -= 1
		turn_page.play()
		_render_page()

## Callback do botão "Próxima Página".
func _on_next_pressed() -> void:
	_next_page()

## Callback do botão "Página Anterior".
func _on_previous_pressed() -> void:
	_previous_page()

## Lida com os eventos de input (cliques e movimento do mouse) para arrastar o livro.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and drag_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
				dragging = true
				drag_offset = get_viewport().get_mouse_position() - book.global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		book.global_position = get_viewport().get_mouse_position() - drag_offset

## Adiciona uma nova página a uma seção específica do livro.
##
## - `section_name`: Nome da seção onde a página será inserida.
## - `page_title`: Título exibido no topo da página.
## - `content1`: Texto principal da página.
## - `content2`: Texto secundário opcional.
func add_page(section_name: String, page_title: String, content1: String, content2: String = "") -> void:
	if not sections.has(section_name):
		sections[section_name] = []
	
	var new_page = {
		"title": page_title,
		"content1": content1,
		"content2": content2
	}
	sections[section_name].append(new_page)

	_flatten_pages()
