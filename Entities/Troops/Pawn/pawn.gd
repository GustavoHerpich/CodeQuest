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

# Private methods

func _ready() -> void:
	add_child(game_object_register)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	_attack()
	_check_particles()

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

func _check_particles() -> void:
	dust.emitting = velocity.length() > 0

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	exit_dialogue_mode()

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == left_attack_name or anim_name == right_attack_name:
		can_attack = true

func _on_actionable_finder_area_entered(_area: Area2D) -> void:
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		var target = actionables[0]
		if target.has_method("action") and target.auto_start:
			if not is_in_dialogue:
				enter_dialogue_mode()
				target.action()

func _on_attack_area_body_entered(_body: Node2D) -> void:
	if _body is PshysicsTree or _body is Sheep:
		_body.update_health([min_attack, max_attack])

#

# Public Methods

func is_busy() -> bool:
	return is_in_terminal or is_in_dialogue or is_in_bookHelper or is_in_wheel

func can_move() -> bool:
	return can_attack and not is_busy()

func enter_terminal() -> void:
	is_in_terminal = true

func exit_terminal() -> void:
	is_in_terminal = false
	
func enter_bookHelper() -> void:
	is_in_bookHelper = true

func exit_bookHelper() -> void:
	is_in_bookHelper = false

func enter_wheel() -> void:
	is_in_wheel = true
	
func exit_wheel() -> void:
	is_in_wheel = false

func enter_dialogue_mode() -> void:
	is_in_dialogue = true
	velocity = Vector2.ZERO

func exit_dialogue_mode() -> void:
	is_in_dialogue = false

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

func update_montain_state(state: bool) -> void:
	is_in_montain = state
	if is_in_montain:
		bridge.z_index = 0
	else:
		bridge.z_index = 1

func get_is_in_mountain() -> bool:
	return is_in_montain

#

# Console integration

func increaseSpeed(amount: float) -> void:
	if moveSpeed() + amount <= 500:
		GameManager.set_value_variable(self, "move_speed", amount)
	else:
		GameManager.print("A velocidade atribuída ultrapassou os limites. Limite: 500, Velocidade Atual: " + str(moveSpeed()))

func moveSpeed() -> Variant:
	return GameManager.get_value_variable(self, "move_speed")

func increaseAttack(min_amount: int, max_amount: int) -> void:
	var current_min_attack = GameManager.get_value_variable(self, "min_attack")
	var current_max_attack = GameManager.get_value_variable(self, "max_attack")
	
	current_min_attack += min_amount
	current_max_attack += max_amount
	
	GameManager.set_value_variable(self, "min_attack", min_amount)
	GameManager.set_value_variable(self, "max_attack", max_amount)
	
	GameManager.print("Ataque aumentado.\nNovo intervalo: " + str(current_min_attack) + " - " + str(current_max_attack))

func attackRange() -> Variant:
	var min_attack = GameManager.get_value_variable(self, "min_attack")
	var max_attack = GameManager.get_value_variable(self, "max_attack")
	return "(" + str(min_attack) + ", " + str(max_attack) + ")" 

#
