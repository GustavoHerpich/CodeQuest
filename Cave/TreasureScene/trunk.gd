class_name Trunk
extends Node2D

var already_interacted: bool = false
@onready var interactable: Interactable = $Interactable
@onready var trunk: Trunk = $"."

func _ready() -> void:
	interactable.interact = _open_trunk

func _open_trunk() -> void:
	if already_interacted:
		return
	
	already_interacted = true
	
	var anim_player: AnimationPlayer = trunk.get_node("Animation")
	if anim_player:
		if anim_player.has_animation(GameConstants.ANIM_OPEN):	 
			anim_player.play(GameConstants.ANIM_OPEN)
			BookManager.add_book_page(
				"funcoes_objetos",
				"👤 Player",
				"👟 [code]increaseSpeed(amount)[/code]\nAumenta a velocidade do jogador em uma certa quantidade.\n\nExemplo:\n[code]increaseSpeed(5)[/code]",
				"⚡ [code]moveSpeed()[/code]\nRetorna a velocidade atual do jogador.\n\nExemplo:\n[code]print(moveSpeed())[/code]"
			)
			
			BookManager.add_book_page(
				"funcoes_objetos",
				"📜 Placas Enigmáticas",
				"🔢 [code]getPlateValue()[/code]\nRetorna o valor oculto da placa.",
				"✅ [code]solvePlate(array)[/code]\nValida se o array está em ordem crescente.\nSe estiver correto, os números serão revelados."
			)

			BookManager.add_book_page(
				"como_programar",
				"📊 Ordenação (sort)",
				"🔄 [code]sort(array)[/code]\nOrdena os elementos de um array em ordem crescente.\n\nExemplo:\n[code]local numeros = {5, 2, 8, 1}\nsort(numeros)\nprint(numeros)[/code]\n\nResultado:\n[code]{1, 2, 5, 8}[/code]",
				"💡 O sort é muito útil quando precisamos organizar dados.\nPor exemplo, se quisermos mostrar uma lista de pontuações ou organizar valores numéricos antes de verificar uma condição."
			)
