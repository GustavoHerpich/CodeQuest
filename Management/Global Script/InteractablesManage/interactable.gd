class_name Interactable
extends Area2D

@export_category("Interaction")
@export var interact_name: String = ""
@export var is_interactable: bool = true
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var auto_start := false

var interact: Callable = func(): pass

func action() -> void:
	if not is_interactable:
		return
	
	if dialogue_resource:
		var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
		if player:
			player.enter_dialogue_mode()
			DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
