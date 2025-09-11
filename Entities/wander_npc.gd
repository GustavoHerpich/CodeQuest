class_name WanderCharacter
extends BaseCharacter

@export var min_wait_time: float = 2.0
@export var max_wait_time: float = 6.0
@export var wander_speed: float = 100.0
@export var animated_sprite: AnimatedSprite2D
@export var wander_timer: Timer
@export var dust: CPUParticles2D
@export var can_wander: bool = true 

var direction: Vector2 = Vector2.ZERO
var current_anim: String = ""
var is_in_dialogue: bool = false

func _ready() -> void:
	add_to_group(GameConstants.GROUP_NPCS)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	_set_new_direction()
	wander_timer.start(randf_range(min_wait_time, max_wait_time))

func can_move() -> bool:
	return can_wander and not is_in_dialogue

func _physics_process(delta: float) -> void:
	dust.emitting = velocity.length() > 0.1
	super._physics_process(delta)

func _move() -> void:
	if not can_move():
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	velocity = direction * wander_speed
	move_and_slide()

func _animate() -> void:
	if velocity.length() > 0.1:
		animated_sprite.flip_h = velocity.x < 0
		_set_anim(GameConstants.ANIM_RUN)
	else:
		_set_anim(GameConstants.ANIM_IDLE)

func _set_anim(anim: String) -> void:
	if current_anim != anim:
		animated_sprite.play(anim)
		current_anim = anim

func _on_wander_timer_timeout() -> void:
	if direction == Vector2.ZERO:
		_set_new_direction()
	else:
		direction = Vector2.ZERO

	wander_timer.start(randf_range(min_wait_time, max_wait_time))

func _set_new_direction() -> void:
	if not can_wander:
		direction = Vector2.ZERO
		return
	
	var dirs = [
		Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN,
		Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1)
	]
	direction = dirs.pick_random().normalized()

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	exit_dialogue_mode()

func enter_dialogue_mode() -> void:
	is_in_dialogue = true

func exit_dialogue_mode() -> void:
	is_in_dialogue = false
