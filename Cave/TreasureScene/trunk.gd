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
				"🔢 [code]getPlateValues()[/code]\nRetorna o valor oculto da placa.",
				"✅ [code]solvePlate(array)[/code]\nValida se o array está em ordem crescente.\nSe estiver correto, os números serão revelados."
			)

			BookManager.add_book_page(
				"como_programar",
				"📊 Ordenação com tabelas",
				"🔄 Em Lua, listas (arrays) são tabelas. Para organizar valores, usamos [code]table.sort()[/code], que coloca os itens em ordem crescente.\n\nExemplo:\n[code]local itens = {\"3\", \"1\", \"2\"}\ntable.sort(itens)\nprint(itens)[/code]\n\nResultado:\n[code]{\"1\", \"2\", \"3\"}[/code]",
				"💡 Ordenar é útil para organizar dados, como nomes, números ou pontuações, antes de usá-los em um programa."
			)
