## Classe que representa o nível do jogo.
## Responsável por gerenciar a cena principal, registrar objetos do jogo
## e controlar o fluxo de finalização do nível.

class_name GameLevel
extends Node2D

@onready var game_object_register := GameObject.new()
@onready var mini_map: CanvasLayer = $MiniMap
@onready var pawn: PlayerPawn = $Decorations/Pawn

## Inicialização do nível e configuração de processamento das crianças
func _ready() -> void:
	add_child(game_object_register)
	
	for node in get_children():
		if node == mini_map:
			continue  
		if node.has_method("set_process"):
			node.set_process(false)
		if node.has_method("set_physics_process"):
			node.set_physics_process(false)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if mini_map and pawn:
		mini_map.player_node = pawn

## Encerra o nível atual e muda para a cena de pós-créditos
func endGame() -> void:
	SceneSwitcher.stored_scenes.clear()

	if SceneSwitcher.current_scene:
		SceneSwitcher.current_scene.queue_free()
		SceneSwitcher.current_scene = null

	get_tree().change_scene_to_file("res://Management/PostCredits/post_credits.tscn")
