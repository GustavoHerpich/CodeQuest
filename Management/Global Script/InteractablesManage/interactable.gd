## Classe que representa objetos ou NPCs interagíveis no jogo.
##
## O Interactable pode iniciar diálogos, acionar eventos customizados
## ou executar lógica definida externamente. Ele se integra tanto com o
## jogador quanto com NPCs via o sistema de diálogos do Godot.
class_name Interactable
extends Area2D

@export_category("Interaction")
@export var interact_name: String = ""
@export var is_interactable: bool = true
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var auto_start := false
@export var npc_owner: WanderCharacter

var interact: Callable = func(): pass


# ----------------------------
# Métodos Públicos
# ----------------------------

## Executa a interação do objeto/NPC.
##
## Caso exista um recurso de diálogo e o objeto esteja interagível,
## inicia o diálogo associado. Também coloca o player e o NPC em
## modo de diálogo, bloqueando movimentação.
func action() -> void:
	if not is_interactable or dialogue_resource == null:
		return
	
	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player:
		player.enter_dialogue_mode()
	
	if npc_owner:
		npc_owner.enter_dialogue_mode()
		
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
