class_name BridgeInteract
extends TileMapLayer

@onready var game_object_register = GameObject.new()
@onready var shadow_interact: TileMapLayer = $"../../TerrainManager/ShadowInteract"

## Private method

func _ready() -> void:
	add_child(game_object_register)

##

## Methods that interact with the console

func moveBridge(direction: String):
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
	
	var movement_offset = target_position * 64
	var tween := get_tree().create_tween()
	
	tween.tween_property(self, "position", self.position + movement_offset, 0.5)

	tween.parallel().tween_property(shadow_interact, "position", shadow_interact.position + movement_offset, 0.5)
