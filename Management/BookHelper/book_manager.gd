## Classe responsável por gerenciar o Livro de Ajuda.
##
## AutoLoad (BookManager)
## Este gerenciador controla a criação, exibição e ocultação do Livro de Ajuda,
## além de atualizar o estado do jogador quando o livro está aberto.
##
## Funcionalidades:
## - Criar instância única do livro quando necessário.
## - Alternar entre mostrar e esconder o livro.
## - Notificar o jogador e o GameManager sobre o estado do livro.
## - Adicionar novas páginas dinamicamente.
extends Node

const BOOK_SCENE := preload("res://Management/BookHelper/book_helper.tscn")
const BOOK_NODE_PATH := "Book"

var book_instance: CanvasLayer = null

## Processa entrada do jogador para abrir/fechar o livro.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(GameConstants.INPUT_OPEN_BOOK):
		toggle_book()

## Define se o jogador está interagindo com o livro.
func _set_player_book_state(is_in_book: bool) -> void:
	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player:
		player.is_in_bookHelper = is_in_book

## Garante que a instância do livro exista na árvore.
func _ensure_book_instance() -> void:
	if not book_instance:
		book_instance = BOOK_SCENE.instantiate()
		get_tree().root.add_child(book_instance)
		book_instance.get_node(BOOK_NODE_PATH).visible = false

## Alterna entre mostrar ou ocultar o livro.
func toggle_book() -> void:
	_ensure_book_instance()
	if is_book_visible():
		hide_book()
	else:
		show_book()

## Mostra o livro e atualiza estado do jogador.
func show_book() -> void:
	_ensure_book_instance()
	book_instance.get_node(BOOK_NODE_PATH).visible = true
	_set_player_book_state(true)
	GameManager.update_mouse_visibility()

## Oculta o livro e atualiza estado do jogador.
func hide_book() -> void:
	if book_instance:
		book_instance.get_node(BOOK_NODE_PATH).visible = false
		_set_player_book_state(false)
		GameManager.update_mouse_visibility()

## Retorna `true` se o livro estiver visível.
func is_book_visible() -> bool:
	return book_instance and book_instance.get_node(BOOK_NODE_PATH).visible

## Adiciona uma nova página ao livro de ajuda.
func add_book_page(section: String, title: String, content1: String, content2: String = "") -> void:
	_ensure_book_instance()
	book_instance.add_page(section, title, content1, content2)
