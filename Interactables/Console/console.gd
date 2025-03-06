extends PanelContainer
class_name Console

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_focus_entered() -> void:
	print(player)
	player.is_in_terminal = true


func _on_focus_exited() -> void:
	player.is_in_terminal = false
