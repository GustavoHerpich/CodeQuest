extends StaticBody2D
class_name PshysicsTree

const HIT_PARTICLES: PackedScene = preload("res://Decoration/Effects/hit_particles.tscn")
const WOOD_COLLECTABLE: PackedScene = preload("res://Interactables/Components/Collectables/wood.tscn")
var _is_dead: bool = false

@export_category("Variables")
@export var _health: int
@export var _min_health: int = 10
@export var _max_health: int = 30
@export var min_wood: int = 1
@export var max_wood: int = 5

@export_category("Objects")
@export var _animation: AnimationPlayer

func _ready() -> void:
	_health = randi_range(_min_health, _max_health)

func update_health(damage_range: Array) -> void: # [1, 5]
	if _is_dead:
		return
		
	_health -= randi_range(damage_range[0], damage_range[1])
	
	_spawn_particles()
	
	if _health <= 0:
		_spawn_wood()
		_is_dead = true
		_animation.play("kill") 
		return
		
	_animation.play("hit")

func _spawn_particles() -> void:
	var hit = HIT_PARTICLES.instantiate()
	hit.global_position = global_position + Vector2(32, 32)
	hit.modulate = Color.SADDLE_BROWN
	hit.emitting = true
	
	get_tree().root.call_deferred("add_child", hit)
	
func _spawn_wood() -> void:
	var wood_amount: int = randi_range(min_wood, max_wood)
	for i in wood_amount:
		var wood: CollectableComponent = WOOD_COLLECTABLE.instantiate()
		wood.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", wood)
		
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		_animation.play("idle")
