class_name BaseCharacter
extends CharacterBody2D

var is_in_terminal: bool = false
var is_in_dialogue: bool = false
var is_in_bookHelper: bool = false
var is_in_montain: bool = true
var can_attack: bool = true
var attack_animation_name: String = ""

@export_category("Variables")
@export var move_speed: float = 200.0
@export var left_attack_name: String = ""
@export var right_attack_name: String = ""
@export var min_attack: int = 1
@export var max_attack: int = 5

@export_category("Objects")
@export var sprite2D: Sprite2D
@export var bridge: TileMapLayer
@export var animation: AnimationPlayer
@export var attack_area_collision: CollisionShape2D
@export var dust: CPUParticles2D

@onready var game_object_register = GameObject.new()
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
@onready var axe_attack_sound: AudioStreamPlayer2D = $Sounds/AxeAttackSound
@onready var hammer_attack_sound: AudioStreamPlayer2D = $Sounds/HammerAttackSound

## Private Methods

func _ready() -> void:
	add_child(game_object_register)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func _physics_process(_delta: float) -> void:
	_move()
	_attack()
	_animate()

func _on_dialogue_ended(_resource: DialogueResource) -> void:
	is_in_dialogue = false

func _move() -> void:
	if is_in_terminal or is_in_dialogue or is_in_bookHelper:
		return
		
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	
	dust.emitting = false
	if _direction:
		dust.emitting = true
	
	velocity = _direction * move_speed
	move_and_slide()

func _attack() -> void:
	if is_in_terminal or is_in_dialogue or is_in_bookHelper:
		return
		
	if Input.is_action_just_pressed("left_attack") and can_attack:
		can_attack = false
		attack_animation_name = left_attack_name
		hammer_attack_sound.play()
		set_physics_process(false)
		
	if Input.is_action_just_pressed("right_attack") and can_attack:
		can_attack = false
		attack_animation_name = right_attack_name
		axe_attack_sound.play()
		set_physics_process(false)

func _animate() -> void:
	if is_in_terminal or is_in_dialogue or is_in_bookHelper:
		animation.play("idle")
		return
	
	if velocity.x > 0:
		sprite2D.flip_h = false
		attack_area_collision.position.x = 48
		
	if velocity.x < 0:
		sprite2D.flip_h = true
		attack_area_collision.position.x = -48
	
	if can_attack == false:
		animation.play(attack_animation_name)
		return
	
	if velocity:
		animation.play("run")
		return
	
	animation.play("idle")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_hammer" or anim_name == "attack_axe":
		can_attack = true
		set_physics_process(true)

func _on_actionable_finder_area_entered(_area: Area2D) -> void:
	var actionables = actionable_finder.get_overlapping_areas()
	if actionables.size() > 0:
		var target = actionables[0]
		if target.has_method("action") and target.auto_start:
			if not is_in_dialogue:
				is_in_dialogue = true
				target.action()

func _on_attack_area_body_entered(_body: Node2D) -> void:
	if (
		_body is PshysicsTree or 
		_body is Sheep
	):
		_body.update_health([min_attack, max_attack])

## 

## Public Methods

func update_collision_layer_mask(type: String) -> void:
	if type == "in":
		set_collision_layer_value(1, false)
		set_collision_layer_value(2, true)
		
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
		
	if type == "out":
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)

func update_montain_state(state: bool) -> void:
	is_in_montain = state
	if is_in_montain == false:
		bridge.z_index = 1
		
	if is_in_montain:
		bridge.z_index = 0
		
func get_is_in_mountain() -> bool:
	return is_in_montain
	
##

## Methods that interact with the console

func increaseSpeed(amount: float) -> void:
	if moveSpeed() + amount <= 500:
		GameManager.set_value_variable(self, "move_speed", amount)
	else:
		GameManager.print("A velocidade atribuída ultrapassou os limites. Limite: 500, Velocidade Atual: " + str(moveSpeed()))

func moveSpeed() -> Variant:
	return GameManager.get_value_variable(self, "move_speed")

##
