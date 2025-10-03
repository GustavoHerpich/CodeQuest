class_name Actionables
extends Area2D

@export_category("Variables")
@export var auto_start: bool = true

@export var phase_dialogues: Array[Dictionary] = []

func action() -> bool:
	for entry in phase_dialogues:
		var phase_name: String = entry.get("phase", "")
		var dialogue_res: DialogueResource = entry.get("dialogue_resource", null) as DialogueResource
		var start_key: String = entry.get("start", "start")
		var max_activations: int = entry.get("max_activations", -1)
		var activations: int = entry.get("activations", 0)
		
		if dialogue_res == null:
			continue
		
		var stage_completed := ProgressManager.is_stage_completed(phase_name)
		
		var can_activate := (max_activations == -1) or (activations < max_activations)
		
		if not stage_completed and can_activate:
			DialogueManager.show_example_dialogue_balloon(dialogue_res, start_key)
			entry["activations"] = activations + 1
			return true
	
	return false
