extends CharacterBody2D
class_name Sheep

const HIT_PARTICLES: PackedScene = preload("res://Decoration/Effects/hit_particles.tscn")
const MEAT_COLLECTABLE: PackedScene = preload("res://Interactables/Components/Collectables/meat.tscn")
var is_dead: bool = false
var health: int

var wait_time: float
var run_wait_time: float

var direction: Vector2

var regular_move_speed: float

@export_category("Variables")
@export var move_speed: float = 128.00
@export var min_health: int = 10
@export var max_health: int = 30
@export var min_meat: int = 1
@export var max_meat: int = 5

@export_category("Objects")
@export var sprite: Sprite2D
@export var animation: AnimationPlayer
@export var walker_timer: Timer
@export var run_timer: Timer
@export var dust: CPUParticles2D

func _ready() -> void:
	regular_move_speed = move_speed
	health =  randf_range(min_health, max_health)
	
	wait_time = randf_range(5.0, 15.0)
	run_wait_time = randf_range(1.0, 3.0)
	
	direction = _get_direction()
	walker_timer.start(wait_time)
	
func _physics_process(_delta: float) -> void:
	dust.emitting = false
	if direction:
		dust.emitting = true
		
	velocity = direction * move_speed
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		direction = velocity.bounce(
			get_slide_collision(0).get_normal()
		).normalized()
		
	_animate()
	
func _animate() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
	
	if velocity.x < 0:
		sprite.flip_h = true
	
	if velocity:
		animation.play("walk")
		return
	
	animation.play("idle")

func _get_direction() -> Vector2:
	return [
		Vector2(-1, 0), Vector2(1, 0), Vector2(-1, -1), Vector2(0, -1),
		Vector2(1, -1), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1),
		Vector2.ZERO
	].pick_random().normalized()

func _on_walk_timer_timeout() -> void:
	walker_timer.start(wait_time)
	if direction == Vector2.ZERO:
		direction = _get_direction()
		return
		
	direction = Vector2.ZERO

func update_health(damage_range: Array) -> void: # [1, 5]
	if is_dead:
		return
		
	health -= randi_range(damage_range[0], damage_range[1])
	
	_spawn_particles()
	
	if health <= 0:
		_spawn_meat()
		is_dead = true
		queue_free()
		return
		
	run_timer.start(run_wait_time)
	direction = _get_direction()
	move_speed *= 2
	
func _spawn_particles() -> void:
	var hit = HIT_PARTICLES.instantiate()
	hit.global_position = global_position
	hit.modulate = Color.RED
	hit.emitting = true
	
	get_tree().root.call_deferred("add_child", hit)

func _spawn_meat() -> void:
	var meat_amount: int = randi_range(min_meat, max_meat)
	for i in meat_amount:
		var meat: CollectableComponent = MEAT_COLLECTABLE.instantiate()
		meat.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", meat)
	
func _on_run_timer_timeout() -> void:
	move_speed = regular_move_speed
