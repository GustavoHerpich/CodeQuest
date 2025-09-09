extends Control

const ALLOWED_ACTIONS := [
	GameConstants.INPUT_MOVE_LEFT,
	GameConstants.INPUT_MOVE_RIGHT,
	GameConstants.INPUT_MOVE_UP,
	GameConstants.INPUT_MOVE_DOWN,
	GameConstants.INPUT_LEFT_ATTACK,
	GameConstants.INPUT_RIGHT_ATTACK,
	GameConstants.INPUT_INTERACT,
	GameConstants.INPUT_OPEN_BOOK,
	GameConstants.INPUT_EXIT
]

@onready var action_list: VBoxContainer = $MarginContainer/ActionList
@onready var settings_menu: VBoxContainer = $"../SettingsMenu"

func _ready():
	_populate_actions()

func _populate_actions():
	for child in action_list.get_children():
		child.queue_free()

	for action in ALLOWED_ACTIONS:
		if not InputMap.has_action(action):
			continue

		var hbox = HBoxContainer.new()

		var label = Label.new()
		label.text = action
		hbox.add_child(label)

		var events = InputMap.action_get_events(action)
		var key_name = events[0].as_text() if events.size() > 0 else "Nenhum"

		var button = Button.new()
		button.text = key_name
		button.pressed.connect(func():
			_remap_action(action, button)
		)

		hbox.add_child(button)
		action_list.add_child(hbox)

func _remap_action(action: String, button: Button):
	button.text = "Pressione tecla..."

	await get_tree().create_timer(0.1).timeout 

	set_process_input(true)
	button.set_meta("action", action)
	button.set_meta("listening", true)

func _input(event):
	for child in action_list.get_children():
		if child is HBoxContainer:
			for btn in child.get_children():
				if btn is Button and btn.get_meta("listening", false):
					if event is InputEventKey and event.pressed:
						var action = btn.get_meta("action")
						
						InputMap.action_erase_events(action)
						InputMap.action_add_event(action, event)

						btn.text = event.as_text()
						btn.set_meta("listening", false)
						set_process_input(false)
						return

func _on_back_pressed():
	visible = false
	settings_menu.visible = true  
