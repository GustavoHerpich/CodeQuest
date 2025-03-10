extends TileMapLayer
class_name Bridge

@onready var game_object_register = GameObject.new()

func _ready() -> void:
	add_child(game_object_register)

func moveBridge():
	# TODO: Modificar para mover apenas uma celula.
	
	var target_position := Vector2(0, 1)
	var tween := get_tree().create_tween()
	
	tween.tween_property(
		self,
		"position",
		self.position + target_position * 50,
		0.5
	)
