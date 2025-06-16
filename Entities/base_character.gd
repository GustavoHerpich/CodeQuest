class_name BaseCharacter
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var sprite2D: Sprite2D
@export var animation: AnimationPlayer

func _physics_process(_delta):
	_move()
	_animate()

func _move():
	if not can_move():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var _direction: Vector2 = Input.get_vector(
		GameConstants.INPUT_MOVE_LEFT, 
		GameConstants.INPUT_MOVE_RIGHT, 
		GameConstants.INPUT_MOVE_UP, 
		GameConstants.INPUT_MOVE_DOWN
	)

	velocity = _direction * move_speed
	move_and_slide()

func _animate():
	return GameConstants.ANIM_RUN if velocity.length() > 0.0 else GameConstants.ANIM_IDLE

func can_move() -> bool:
	return true
