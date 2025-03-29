extends CanvasLayer

var current_scene = null
var player = null
var stored_scenes = {}
var default_environment = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $ColorRect
@onready var global_environment: WorldEnvironment = $WorldEnvironment

## Métodos Privados 

func _ready() -> void:
	color_rect.visible = false
	_initialize_scene()
	_find_player()
	_store_default_environment()

func _initialize_scene() -> void:
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func _find_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _store_default_environment() -> void:
	if global_environment.environment:
		default_environment = global_environment.environment.duplicate()

func _deferred_switch_scene(res_path: String, area_to_reactivate: Area2D = null, spawn_name: String = "SpawnPoint") -> void:
	if not player:
		print("⚠️ ERRO: O jogador não foi encontrado! Cancelando troca de cena.")
		return

	_fade_in()
	_remove_player_from_current_scene()
	_change_scene(res_path)
	_position_player(spawn_name)
	_update_environment()
	_fade_out()
	_reactivate_area(area_to_reactivate)

func _fade_in() -> void:
	color_rect.visible = true
	animation_player.play("fade_in")
	await animation_player.animation_finished

func _fade_out() -> void:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	color_rect.visible = false

func _remove_player_from_current_scene() -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)

func _change_scene(res_path: String) -> void:
	if stored_scenes.has(res_path):
		if current_scene:
			current_scene.hide()
		current_scene = stored_scenes[res_path]
		current_scene.show()
	else:
		if current_scene:
			current_scene.hide()
			stored_scenes[current_scene.scene_file_path] = current_scene
		
		var scene = load(res_path).instantiate()
		get_tree().root.add_child(scene)
		current_scene = scene
		stored_scenes[res_path] = scene

func _position_player(spawn_name: String) -> void:
	var spawn_point = current_scene.get_node_or_null(spawn_name)
	if spawn_point:
		player.global_position = spawn_point.global_position
	
	var decorations = current_scene.get_node_or_null("Decorations")
	if decorations:
		decorations.call_deferred("add_child", player)
		decorations.call_deferred("move_child", player, 0)
	else:
		current_scene.call_deferred("add_child", player)

func _update_environment() -> void:
	var new_env = current_scene.get_node_or_null("WorldEnvironment")
	global_environment.environment = new_env.environment if new_env else default_environment

func _reactivate_area(area_to_reactivate: Area2D) -> void:
	if area_to_reactivate:
		area_to_reactivate.set_deferred("monitoring", true)
		area_to_reactivate.changing_scene = false

##

## Métodos Pubicos 

func switch_scene(res_path: String, area_to_reactivate: Area2D = null, spawn_name: String = "SpawnPoint") -> void:
	call_deferred("_deferred_switch_scene", res_path, area_to_reactivate, spawn_name)

##
