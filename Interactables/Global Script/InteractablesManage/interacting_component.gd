class_name InteractingComponent
extends Node2D

@onready var interact_label: Label = $InteractLabel

var current_interactions: Array[Interactable] = []
var can_interact := true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions.size() > 0:
			can_interact = false
			interact_label.hide()
			
			var target = current_interactions[0]
			if not target.auto_start:
				await target.action()
			
			await target.interact.call()
			
			can_interact = true

func _process(_delta: float) -> void:
	if current_interactions.size() > 0 and can_interact:
		current_interactions.sort_custom(_sort_by_nearest)
		var target = current_interactions[0]
		if target.is_interactable:
			interact_label.text = target.interact_name
			interact_label.show()
		else:
			interact_label.hide()
	else:
		interact_label.hide()

func _sort_by_nearest(a: Interactable, b: Interactable) -> bool:
	return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)

func _on_interact_range_area_entered(area: Area2D) -> void:
	if area is Interactable and not current_interactions.has(area):
		current_interactions.append(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	if area is Interactable:
		current_interactions.erase(area)
