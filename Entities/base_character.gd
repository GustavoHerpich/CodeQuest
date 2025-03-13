class_name BaseCharacter
extends CharacterBody2D

var is_in_terminal: bool = false
var is_in_montain: bool = true
var can_attack: bool = true
var attack_animation_name: String = ""

@export_category("Variables")
@export var move_speed: float = 200.0
@export var left_attack_name: String = ""
@export var right_attack_name: String = ""

@export_category("Objects")
@export var sprite2D: Sprite2D
@export var bridge: TileMapLayer
@export var animation: AnimationPlayer

@onready var game_object_register = GameObject.new()

## Private Methods

func _ready() -> void:
	update_montain_state(is_in_montain)
	add_child(game_object_register)

func _physics_process(_delta: float) -> void:
	_move()
	_attack()
	_animate()
	
func _move() -> void:
	if is_in_terminal:
		return
		
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)
	velocity = _direction * move_speed
	move_and_slide()

func _attack() -> void:
	if is_in_terminal:
		return
		
	if Input.is_action_just_pressed("left_attack") and can_attack:
		can_attack = false
		attack_animation_name = left_attack_name
		set_physics_process(false)
		
	if Input.is_action_just_pressed("right_attack") and can_attack:
		can_attack = false
		attack_animation_name = right_attack_name
		set_physics_process(false)

func _animate() -> void:
	if is_in_terminal:
		animation.play("idle")
		return
	
	if velocity.x > 0:
		sprite2D.flip_h = false
		
	if velocity.x < 0:
		sprite2D.flip_h = true
	
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
	GameManager.print("Você aumentou sua velocidade para %s." %amount)
	GameManager.set_value_variable(self, "move_speed", amount)

##
