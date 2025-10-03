# ProgressManager.gd
extends Node

var completed_stages: Array[String] = []
var current_stage: String = ""
var stage_dialogues: Dictionary = {} 

signal stage_completed(stage: String)
signal stage_unlocked(stage: String)

func complete_stage(stage_name: String) -> void:
	if stage_name not in completed_stages:
		completed_stages.append(stage_name)
		stage_completed.emit(stage_name)

func is_stage_completed(stage_name: String) -> bool:
	return stage_name in completed_stages

func unlock_stage(stage_name: String) -> void:
	stage_unlocked.emit(stage_name)

func set_current_stage(stage_name: String) -> void:
	current_stage = stage_name

func get_current_dialogue() -> String:
	var unlocked = completed_stages + [current_stage]
	var highest_stage: String = ""
	for stage in unlocked:
		if stage in stage_dialogues:
			highest_stage = stage
	return stage_dialogues.get(highest_stage, "")
