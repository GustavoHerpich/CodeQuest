## Classe que representa o personagem controlável do jogador.
##
## O PlayerPawn herda de BaseCharacter e adiciona comportamentos de ataque,
## movimentação, interação com NPCs/objetos, além de integração com o Console
## para manipulação de atributos em tempo de execução.

class_name PlayerPawn
extends BaseCharacter

@export_category("Attack")
@export var left_attack_name: String = "attack_hammer"
@export var right_attack_name: String = "attack_axe"
@export var min_attack: int = 1
@export var max_attack: int = 5

@export_category("Objects")
@export var dust: CPUParticles2D
@export var axe_attack_sound: AudioStreamPlayer2D
@export var hammer_attack_sound: AudioStreamPlayer2D
@export var bridge: TileMapLayer
@export var attack_area_collision: CollisionShape2D

var can_attack: bool = true
var attack_animation_name: String = ""
var is_in_terminal: bool = false
var is_in_dialogue: bool = false
var is_in_bookHelper: bool = false
var is_in_wheel: bool = false
var is_in_montain: bool = true

@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var game_object_register = GameObject.new()

## Inicialização do personagem e configuração de sinais.
func _ready() -> void:
	add_child(game_object_register)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

## Lógica de movimentação, ataque e partículas executada a cada frame de física.
func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	_attack()
	_check_particles()

## Executa ataques corpo a corpo com base nas teclas pressionadas.
func _attack() -> void:
	if is_busy(): return
	
	if Input.is_action_just_pressed(GameConstants.INPUT_LEFT_ATTACK) and can_attack:
		can_attack = false
		attack_animation_name = left_attack_name
		hammer_attack_sound.play()

	elif Input.is_action_just_pressed(GameConstants.INPUT_RIGHT_ATTACK) and can_attack:
		can_attack = false
		attack_animation_name = right_attack_name
		axe_attack_sound.play()

## Atualiza animações do personagem com base em ataques e movimentação.
func _animate() -> void:
	if is_busy():
		animation.play(GameConstants.ANIM_IDLE)
		return
	
	if velocity.x > 0:
		sprite2D.flip_h = false
		attack_area_collision.position.x = 48
		
	elif velocity.x < 0:
		sprite2D.flip_h = true
		attack_area_collision.position.x = -48
	
	if can_attack == false:
		animation.play(attack_animation_name)
		return
	
	if velocity:
		animation.play(GameConstants.ANIM_RUN)
		return
	
	animation.play(GameConstants.ANIM_IDLE)

## Controla a emissão de partículas (poeira) durante a movimentação.
func _check_particles() -> void:
	dust.emitting = velocity.length() > 0

## Evento chamado quando um diálogo termina.
func _on_dialogue_ended(_resource: DialogueResource) -> void:
	exit_dialogue_mode()

## Evento chamado ao terminar uma animação de ataque.
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == left_attack_name or anim_name == right_attack_name:
		can_attack = true

## Evento disparado ao entrar em uma área de interação (NPCs/objetos).
func _on_actionable_finder_area_entered(_area: Area2D) -> void:
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		var target = actionables[0]
		if target.has_method("action") and target.auto_start:
			if not is_in_dialogue and not target.used:
				enter_dialogue_mode()
				target.action()

## Evento disparado quando a área de ataque atinge um inimigo/objeto.
func _on_attack_area_body_entered(_body: Node2D) -> void:
	if _body is PshysicsTree or _body is Sheep:
		_body.update_health([min_attack, max_attack])

# ----------------------------
# Métodos Públicos
# ----------------------------

## Retorna `true` se o personagem estiver em alguma interação que o impeça de agir.
func is_busy() -> bool:
	return is_in_terminal or is_in_dialogue or is_in_bookHelper or is_in_wheel

## Retorna `true` se o personagem pode se mover.
func can_move() -> bool:
	return can_attack and not is_busy()

## Marca o personagem como dentro de um terminal.
func enter_terminal() -> void:
	is_in_terminal = true

## Marca o personagem como fora de um terminal.
func exit_terminal() -> void:
	is_in_terminal = false
	
## Marca o personagem como dentro do Livro de Ajuda.
func enter_bookHelper() -> void:
	is_in_bookHelper = true

## Marca o personagem como fora do Livro de Ajuda.
func exit_bookHelper() -> void:
	is_in_bookHelper = false

## Marca o personagem como dentro da roleta.
func enter_wheel() -> void:
	is_in_wheel = true
	
## Marca o personagem como fora da roleta.
func exit_wheel() -> void:
	is_in_wheel = false

## Entra no modo de diálogo, bloqueando movimentação.
func enter_dialogue_mode() -> void:
	is_in_dialogue = true
	velocity = Vector2.ZERO

## Sai do modo de diálogo.
func exit_dialogue_mode() -> void:
	is_in_dialogue = false

## Atualiza as camadas e máscaras de colisão do personagem.
##
## - `type`: "in" ou "out" para definir o estado.
func update_collision_layer_mask(type: String) -> void:
	if type == "in":
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
	elif type == "out":
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)

## Atualiza o estado de "montanha" do personagem e ajusta a camada da ponte.
func update_montain_state(state: bool) -> void:
	is_in_montain = state
	if is_in_montain:
		bridge.z_index = 0
	else:
		bridge.z_index = 1

## Retorna se o personagem está na montanha.
func get_is_in_mountain() -> bool:
	return is_in_montain

# ----------------------------
# Integração com Console
# ----------------------------

## Aumenta a velocidade de movimento do personagem, até o limite de 500.
func increaseSpeed(amount: float) -> void:
	var current_speed = moveSpeed()
	var new_speed = current_speed + amount
	
	if new_speed <= 500 and new_speed >= 0:
		GameManager.set_value_variable(self, "move_speed", amount)
		GameManager.print("⚡ Velocidade alterada!\nAntes: " + str(current_speed) + "\nDepois: " + str(new_speed))
	else:
		GameManager.print("❌ Velocidade fora dos limites (0 - 500).\nAtual: " + str(current_speed) + "\nTentativa: " + str(new_speed))

## Retorna a velocidade de movimento atual do personagem.
func moveSpeed() -> Variant:
	return GameManager.get_value_variable(self, "move_speed")

## Aumenta o ataque mínimo e máximo do personagem.
func increaseAttack(min_amount: int, max_amount: int) -> void:
	var current_min_attack = GameManager.get_value_variable(self, "min_attack")
	var current_max_attack = GameManager.get_value_variable(self, "max_attack")
	
	current_min_attack += min_amount
	current_max_attack += max_amount
	
	GameManager.set_value_variable(self, "min_attack", min_amount)
	GameManager.set_value_variable(self, "max_attack", max_amount)
	
	GameManager.print("Ataque aumentado.\nNovo intervalo: " + str(current_min_attack) + " - " + str(current_max_attack))

## Retorna o intervalo de ataque atual em formato string.
func attackRange() -> Variant:
	var min_val = GameManager.get_value_variable(self, "min_attack")
	var max_val = GameManager.get_value_variable(self, "max_attack")
	return "(" + str(min_val) + ", " + str(max_val) + ")"
