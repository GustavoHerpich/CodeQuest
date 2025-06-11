class_name Actionables
extends Area2D

@export_category("Variables")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var auto_start = true

func action() -> void:
	if dialogue_resource:
		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
