## Classe que representa a ovelha NPC no jogo.
##
## A Sheep possui movimentação aleatória, animações de andar, comer e idle,
## gerenciamento de vida, partículas de dano e geração de itens (carne) ao morrer.

class_name Sheep
extends CharacterBody2D

const HIT_PARTICLES: PackedScene = preload("res://Decoration/Effects/hit_particles.tscn")
const MEAT_COLLECTABLE: PackedScene = preload("res://Interactables/Components/Collectables/meat.tscn")

var is_dead: bool = false
var health: int
var wait_time: float
var run_wait_time: float
var direction: Vector2
var regular_move_speed: float
var current_anim: String = ""
var idle_time: float = 0.0
var is_eating: bool = false

@export_category("Variables")
@export var move_speed: float = 128.0
@export var min_health: int = 10
@export var max_health: int = 30
@export var min_meat: int = 1
@export var max_meat: int = 5

@export_category("Objects")
@export var animatedSprite: AnimatedSprite2D
@export var walker_timer: Timer
@export var run_timer: Timer
@export var dust: CPUParticles2D

## Inicializa variáveis, direção e timers da ovelha.
func _ready() -> void:
	regular_move_speed = move_speed
	health = randi_range(min_health, max_health)
	wait_time = randf_range(5.0, 15.0)
	run_wait_time = randf_range(1.0, 3.0)
	direction = _get_direction()
	walker_timer.start(wait_time)

## Processa física, movimentação, colisões e animações.
func _physics_process(delta: float) -> void:
	dust.emitting = false
	if direction:
		dust.emitting = true

	velocity = direction * move_speed
	move_and_slide()

	if get_slide_collision_count() > 0:
		direction = velocity.bounce(
			get_slide_collision(0).get_normal()
		).normalized()

	idle_time += delta
	_animate()

## Atualiza animações com base na movimentação ou estado de comer.
func _animate() -> void:
	if velocity.length() > 0.1:
		animatedSprite.flip_h = velocity.x < 0
		_set_anim(GameConstants.ANIM_WALK)
		is_eating = false
		idle_time = 0.0
	else:
		if not is_eating and idle_time > 2.0 and randf() < 0.05:
			is_eating = true
			_set_anim(GameConstants.ANIM_EAT)
		elif not is_eating:
			_set_anim(GameConstants.ANIM_IDLE)

## Aplica a animação se for diferente da atual.
func _set_anim(anim: String) -> void:
	if current_anim != anim:
		animatedSprite.play(anim)
		current_anim = anim

## Reseta estado de comer ao finalizar animação de comer.
func _on_animated_sprite_animation_finished() -> void:
	if current_anim == GameConstants.ANIM_EAT:
		is_eating = false

## Retorna uma direção aleatória para movimentação.
func _get_direction() -> Vector2:
	return [
		Vector2(-1, 0), Vector2(1, 0), Vector2(-1, -1), Vector2(0, -1),
		Vector2(1, -1), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1),
		Vector2.ZERO
	].pick_random().normalized()

## Timer de movimento aleatório: alterna entre direção e pausa.
func _on_walk_timer_timeout() -> void:
	walker_timer.start(wait_time)
	if direction == Vector2.ZERO:
		direction = _get_direction()
		return

	direction = Vector2.ZERO

## Aplica dano à ovelha, gera partículas e carne se morrer.
func update_health(damage_range: Array) -> void:
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

## Gera partículas de hit na posição da ovelha.
func _spawn_particles() -> void:
	var hit = HIT_PARTICLES.instantiate()
	hit.global_position = global_position
	hit.modulate = Color.RED
	hit.emitting = true

	get_tree().root.call_deferred("add_child", hit)

## Gera carne como coletável ao morrer.
func _spawn_meat() -> void:
	var meat_amount: int = randi_range(min_meat, max_meat)
	for i in meat_amount:
		var meat: CollectableComponent = MEAT_COLLECTABLE.instantiate()
		meat.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		get_tree().root.call_deferred("add_child", meat)

## Reseta velocidade após boost de corrida.
func _on_run_timer_timeout() -> void:
	move_speed = regular_move_speed
