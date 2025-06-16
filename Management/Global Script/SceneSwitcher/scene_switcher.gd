extends CanvasLayer

var current_scene = null
var player = null
var stored_scenes = {}
var default_environment = null

@onready var animation_player = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var global_environment = $WorldEnvironment

## Private Methods

func _ready() -> void:
	color_rect.visible = false

	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

	var players = get_tree().get_nodes_in_group(GameConstants.GROUP_PLAYER)
	if players.size() > 0:
		player = players[0]

	if global_environment.environment:
		default_environment = global_environment.environment.duplicate()

## -- Troca de Cena --

func _deferred_switch_scene(res_path, area_to_reactivate: Area2D = null, spawn_name: String = "SpawnPoint"):
	color_rect.visible = true
	animation_player.play("fade_in")
	await animation_player.animation_finished

	var previous_scene = current_scene

	# -- Carregar ou reusar a nova cena --
	if stored_scenes.has(res_path):
		current_scene = stored_scenes[res_path]
	else:
		var new_scene = load(res_path).instantiate()
		get_tree().root.add_child(new_scene)

		if new_scene is Node2D:
			new_scene.position = Vector2.ZERO

		current_scene = new_scene
		stored_scenes[res_path] = new_scene
	
	# -- Desativar cena antiga --
	if previous_scene and previous_scene != current_scene:
		previous_scene.hide()
		stored_scenes[previous_scene.scene_file_path] = previous_scene

	# -- Ativar nova cena -
	current_scene.show()
	
	# -- Garantir que o player está definido --
	if player == null:
		var players = get_tree().get_nodes_in_group(GameConstants.GROUP_PLAYER)
		if players.size() > 0:
			player = players[0]

	if player.get_parent():
		player.get_parent().remove_child(player)

	# -- Posicionar o player --
	var spawn_point = current_scene.get_node_or_null("SpawnPoints/%s" % spawn_name)
	if spawn_point:
		player.global_position = spawn_point.global_position
	
	var decorations = current_scene.get_node_or_null("Decorations")
	if decorations:
		decorations.call_deferred("add_child", player)
		decorations.call_deferred("move_child", player, 0)
	else:
		current_scene.call_deferred("add_child", player)

	# -- Ajustar ambiente --
	var new_env = current_scene.get_node_or_null("WorldEnvironment")
	if new_env:
		global_environment.environment = new_env.environment
	else:
		global_environment.environment = default_environment

	# -- Concluir transição --
	animation_player.play("fade_out")
	await animation_player.animation_finished
	color_rect.visible = false
	
	if area_to_reactivate:
		area_to_reactivate.set_deferred("monitoring", true)
		area_to_reactivate.changing_scene = false

## Public Methods

func switch_scene(res_path, area_to_reactivate: Area2D = null, spawn_name: String = "SpawnPoint"):
	call_deferred("_deferred_switch_scene", res_path, area_to_reactivate, spawn_name)

##
