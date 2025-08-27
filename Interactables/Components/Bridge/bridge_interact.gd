class_name BridgeInteract
extends TileMapLayer

var movement_queue: Array[String] = []
var is_moving := false

@onready var game_object_register = GameObject.new()
@onready var shadow_interact: TileMapLayer = $"../../TerrainManager/ShadowInteract"
@onready var pawn: BaseCharacter = $"../../Decorations/Pawn"

## Private method

func _ready() -> void:
	add_child(game_object_register)

##

## Methods that interact with the console

func moveBridge(direction: String) -> void:
	movement_queue.append(direction.to_lower())
	if not is_moving:
		_process_movement_queue()

func _process_movement_queue() -> void:
	if movement_queue.is_empty():
		is_moving = false
		return
	
	is_moving = true
	var direction: String = movement_queue.pop_front()
	var target_position := Vector2.ZERO

	match direction:
		"up":
			target_position.y -= 1
		"down":
			target_position.y += 1
		"left":
			target_position.x -= 1
		"right":
			target_position.x += 1
		_:
			GameManager.error("🔁 Direção inválida: " + direction)
			is_moving = false
			return
	
	var movement_offset = target_position * 64
	var tween := get_tree().create_tween()
	tween.tween_property(self, "position", self.position + movement_offset, 0.5)
	tween.parallel().tween_property(shadow_interact, "position", shadow_interact.position + movement_offset, 0.5)
	
	tween.finished.connect(_process_movement_queue)
	
