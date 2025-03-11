class_name Bridge
extends TileMapLayer

@onready var game_object_register = GameObject.new()

## Private method

func _ready() -> void:
	add_child(game_object_register)

##

## Methods that interact with the console

func moveBridge(position: String):
	# TODO: Modificar para mover apenas uma celula.
	var target_position := Vector2.ZERO
	match (position):
		"up":
			target_position.y -= 1
		"down":
			target_position.y += 1
		"left":
			target_position.x -= 1
		"right":
			target_position.x += 1
			
	var tween := get_tree().create_tween()
	tween.tween_property(
		self,
		"position",
		self.position + target_position * 50,
		0.5
	)
	
##
