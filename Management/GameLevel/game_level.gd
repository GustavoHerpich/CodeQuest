## Classe que representa o nível do jogo.
## Responsável por gerenciar a cena principal, registrar objetos do jogo
## e controlar o fluxo de finalização do nível.

class_name GameLevel
extends Node2D

@onready var game_object_register := GameObject.new()
@onready var mini_map: CanvasLayer = $MiniMap

@export_node_path("PlayerPawn") var pawn_path: NodePath
var pawn: PlayerPawn

## Inicialização do nível e configuração de processamento das crianças
func _ready() -> void:
	add_child(game_object_register)
	
	if pawn_path and has_node(pawn_path):
		pawn = get_node(pawn_path)
		
	for node in get_children():
		if node == mini_map:
			continue  
		if node.has_method("set_process"):
			node.set_process(false)
		if node.has_method("set_physics_process"):
			node.set_physics_process(false)

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if mini_map and pawn:
		mini_map.set_player(pawn)

## Encerra o nível atual e muda para a cena de pós-créditos
func endGame() -> void:
	ProgressManager.complete_stage("end")
	SceneSwitcher.stored_scenes.clear()

	if SceneSwitcher.current_scene:
		SceneSwitcher.current_scene.queue_free()
		SceneSwitcher.current_scene = null

	get_tree().change_scene_to_file("res://Management/PostCredits/post_credits.tscn")
