extends Node

const BookScene := preload("res://Interactables/BookHelper/book_helper.tscn")
var book_instance: CanvasLayer = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_book"):
		toggle_book()

func _set_player_book_state(is_in_book: bool) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.is_in_bookHelper = is_in_book

func toggle_book() -> void:
	if book_instance and book_instance.get_node("Book").visible:
		hide_book()
	else:
		show_book()

func show_book() -> void:
	if not book_instance:
		book_instance = BookScene.instantiate()
		get_tree().root.add_child(book_instance)

	book_instance.get_node("Book").visible = true
	_set_player_book_state(true)
	GameManager.update_mouse_visibility()

func hide_book() -> void:
	if book_instance:
		book_instance.get_node("Book").visible = false
		_set_player_book_state(false)
		GameManager.update_mouse_visibility()

func add_book_page(section: String, title: String, content1: String, content2: String = "") -> void:
	if not book_instance:
		book_instance = BookScene.instantiate()
		book_instance.get_node("Book").visible = false
		get_tree().root.add_child(book_instance)

	book_instance.add_page(section, title, content1, content2)
