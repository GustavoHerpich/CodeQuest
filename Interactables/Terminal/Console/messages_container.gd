class_name MessageContainer
extends VBoxContainer

@onready var info_template: Label = $Info
@onready var error_template: Label = $Error

func _on_clear_pressed() -> void:
	for child in get_children():
		if not child.is_queued_for_deletion() and child != info_template and child != error_template:
			remove_child(child)
			child.queue_free()
			
func add_error(message: String):
	var label: Label = error_template.duplicate()
	label.text = "[ERRO] [" + Time.get_time_string_from_system() + "] " + message
	label.visible = true
	add_child(label)

func add_info(message: String):
	var label: Label = info_template.duplicate()
	label.text = message
	label.visible = true
	add_child(label)
