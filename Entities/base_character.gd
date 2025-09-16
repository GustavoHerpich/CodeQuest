## Classe base para personagens controláveis.
##
## O BaseCharacter herda de CharacterBody2D e provê movimentação,
## animação e métodos genéricos que podem ser reutilizados por classes derivadas.

class_name BaseCharacter
extends CharacterBody2D

@export var move_speed: float = 200.0
@export var sprite2D: Sprite2D
@export var animation: AnimationPlayer

## Processamento a cada frame de física.
func _physics_process(_delta):
	_move()
	_animate()

## Atualiza a movimentação do personagem.
func _move():
	if not can_move():
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction: Vector2 = Input.get_vector(
		GameConstants.INPUT_MOVE_LEFT,
		GameConstants.INPUT_MOVE_RIGHT,
		GameConstants.INPUT_MOVE_UP,
		GameConstants.INPUT_MOVE_DOWN
	)

	velocity = direction * move_speed
	move_and_slide()

## Retorna a animação atual com base na velocidade do personagem.
func _animate():
	return GameConstants.ANIM_RUN if velocity.length() > 0.0 else GameConstants.ANIM_IDLE

## Retorna `true` se o personagem pode se mover.
func can_move() -> bool:
	return true
