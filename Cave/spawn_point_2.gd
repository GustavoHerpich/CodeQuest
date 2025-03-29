extends Marker2D
@onready var enter_treasure = get_node("TreasureLayer/Enter_Treasure")

func _ready() -> void:
	connect("body_entered", enter_treasure, "_on_marker2d_reached")
