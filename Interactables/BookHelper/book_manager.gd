extends Node

const BOOK_SCENE := preload("res://Interactables/BookHelper/book_helper.tscn")
const BOOK_NODE_PATH := "Book"

var book_instance: CanvasLayer = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_book"):
		toggle_book()

func _set_player_book_state(is_in_book: bool) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		player.is_in_bookHelper = is_in_book

func _ensure_book_instance() -> void:
	if not book_instance:
		book_instance = BOOK_SCENE.instantiate()
		get_tree().root.add_child(book_instance)
		book_instance.get_node(BOOK_NODE_PATH).visible = false

func toggle_book() -> void:
	_ensure_book_instance()
	if is_book_visible():
		hide_book()
	else:
		show_book()

func show_book() -> void:
	_ensure_book_instance()
	book_instance.get_node(BOOK_NODE_PATH).visible = true
	_set_player_book_state(true)
	GameManager.update_mouse_visibility()

func hide_book() -> void:
	if book_instance:
		book_instance.get_node(BOOK_NODE_PATH).visible = false
		_set_player_book_state(false)
		GameManager.update_mouse_visibility()

func is_book_visible() -> bool:
	return book_instance and book_instance.get_node(BOOK_NODE_PATH).visible

func add_book_page(section: String, title: String, content1: String, content2: String = "") -> void:
	_ensure_book_instance()
	book_instance.add_page(section, title, content1, content2)
