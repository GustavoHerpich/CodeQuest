class_name PshysicsTree
extends StaticBody2D

const HIT_PARTICLES: PackedScene = preload("res://Decoration/Effects/hit_particles.tscn")
const WOOD_COLLECTABLE: PackedScene = preload("res://Interactables/Components/Collectables/wood.tscn")
var is_dead: bool = false

@export_category("Variables")
@export var health: int
@export var min_health: int = 10
@export var max_health: int = 30
@export var min_wood: int = 1
@export var max_wood: int = 5

@export_category("Objects")
@export var animation: AnimationPlayer

func _ready() -> void:
	health = randi_range(min_health, max_health)

func update_health(damage_range: Array) -> void:
	if is_dead:
		return
		
	health -= randi_range(damage_range[0], damage_range[1])
	_spawn_particles()
	
	if health <= 0:
		_spawn_wood()
		is_dead = true
		animation.play(GameConstants.ANIM_KILL)
	else:
		animation.play(GameConstants.ANIM_HIT)

func _spawn_particles() -> void:
	var hit = HIT_PARTICLES.instantiate()
	hit.global_position = global_position + Vector2(32, 32)
	hit.modulate = get_hit_color()
	hit.emitting = true
	get_tree().root.call_deferred("add_child", hit)

func _spawn_wood() -> void:
	var wood_amount: int = randi_range(min_wood, max_wood)
	for i in wood_amount:
		var wood = WOOD_COLLECTABLE.instantiate()
		wood.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		get_tree().root.call_deferred("add_child", wood)

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == GameConstants.ANIM_HIT:
		animation.play(GameConstants.ANIM_IDLE)

func get_hit_color() -> Color:
	return Color.SADDLE_BROWN
