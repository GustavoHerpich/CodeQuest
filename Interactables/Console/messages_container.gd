class_name MessageContainer
extends VBoxContainer

@onready var info_template: Label = $Info
@onready var error_template: Label = $Error

func _on_clear_pressed() -> void:
	var children := self.get_children()
	
	for child in children:
		if child != info_template && child != error_template:
			child.queue_free() 
			
func add_error(message: String):
	var label : Label = error_template.duplicate()
	label.text = message
	label.visible = true
	
	self.add_child(label)

func add_info(message: String):
	var label : Label = info_template.duplicate()
	label.text = message
	label.visible = true
	
	self.add_child(label)
