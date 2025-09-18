class_name Actionables
extends Area2D

@export_category("Variables")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var auto_start = true

@export var max_activations: int = -1 # -1 = ilimitado
var current_activations: int = 0

# Marca se já foi usado (para max_activations == 1)
var used: bool = false

func action() -> void:
	if dialogue_resource:
		if max_activations != -1 and current_activations >= max_activations:
			return

		DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
		current_activations += 1
		if max_activations == 1:
			used = true
