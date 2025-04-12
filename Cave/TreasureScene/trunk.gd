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
			BookManager.add_book_page(
				"funcoes_objetos",
				"👤 Player",
				"👟 [code]increaseSpeed(amount)[/code]\nAumenta a velocidade do jogador em uma certa quantidade.\n\nExemplo:\n[code]increaseSpeed(5)[/code]",
				"⚡ [code]moveSpeed()[/code]\nRetorna a velocidade atual do jogador.\n\nExemplo:\n[code]print(moveSpeed())[/code]"
			)
