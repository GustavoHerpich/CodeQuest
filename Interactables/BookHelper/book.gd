class_name Book
extends CanvasLayer

var pages: Array = []
var current_page: int = 0
var dragging := false
var drag_offset := Vector2.ZERO

@onready var title: Label = $Book/Title
@onready var content_text: RichTextLabel = $Book/Content1
@onready var content_text_2: RichTextLabel = $Book/Content2
@onready var book: Control = $Book
@onready var drag_area: Control = $Book/DragArea

func _ready() -> void:
	_load_pages()
	_update_page()

func _load_pages() -> void:
	pages = [
		{
			"title": "Bem-vindo ao Livro de Ajuda",
			"content1": "[center][b]Bem-vindo, aventureiro![/b][/center]\n\nAqui você encontrará tudo que precisa para resolver os desafios.\n\nUse as setas abaixo para navegar pelas páginas.",
			"content2": "[center]\n[b]📖 Dica:[/b] Preste atenção nos nomes das funções e exemplos.\nEles irão te ajudar a aprender programação de forma divertida![/center]"
		},
		{
			"title": "Funções dos Objetos",
			"content1": "[b]🔧 Ponte:[/b]\n[code]moveBridge(direction)[/code]\nDireções possíveis: 'up', 'down', 'left', 'right'\n\nExemplo:\n[code]moveBridge(\"down\")[/code]",
			"content2": "[b]🔐 Porta:[/b]\n[code]getDoorValues()[/code] → Retorna lista de valores da porta\n[code]showPassword(valor)[/code] → Mostra a senha se o valor estiver correto\n[code]openDoor(senha)[/code] → Tenta abrir a porta com a senha\n\nExemplo:\n[code]showPassword(4)[/code]"
		},
		{
			"title": "Como Programar em Lua",
			"content1": "[b]🔁 Repetição (for):[/b]\n[code]for i = 1, 5 do\n  print(i)\nend[/code]\n\n[b]🔀 Condicional (if):[/b]\n[code]if x > 0 then\n  print(\"Positivo\")\nend[/code]",
			"content2": "[b]🧠 Funções:[/b]\n[code]function minha_funcao(param)\n  print(param)\nend\n\nminha_funcao(\"Olá\")[/code]\n\n[b]💡 Dica:[/b] Combine estruturas para resolver os desafios do jogo!"
		}
	]

func _update_page() -> void:
	if current_page >= 0 and current_page < pages.size():
		var page = pages[current_page]
		title.text = page["title"]
		content_text.text = page["content1"]
		content_text_2.text = page["content2"]

func _on_next_pressed() -> void:
	if current_page < pages.size() - 1:
		current_page += 1
		_update_page()

func _on_previous_pressed() -> void:
	if current_page > 0:
		current_page -= 1
		_update_page()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if drag_area.get_global_rect().has_point(get_viewport().get_mouse_position()):
					dragging = true
					drag_offset = get_viewport().get_mouse_position() - book.global_position
			else:
				dragging = false

	elif event is InputEventMouseMotion and dragging:
		book.global_position = get_viewport().get_mouse_position() - drag_offset
