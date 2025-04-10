class_name Trunk
extends Node2D

@onready var interactable: Interactable = $Interactable
@onready var trunk: Trunk = $"."

func _ready() -> void:
	interactable.interact = _open_trunk

func _open_trunk() -> void:
	var anim_player: AnimationPlayer = trunk.get_node("Animation")
	if anim_player:
		if anim_player.has_animation("open"):	 
			anim_player.play("open")
