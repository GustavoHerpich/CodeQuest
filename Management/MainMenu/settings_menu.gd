extends VBoxContainer

@onready var input_settings_menu: Control = $"../InputSettingsMenu"

func _on_configure_inputs_pressed() -> void:
	input_settings_menu.visible = true
	self.visible = false
