class_name MainMenu
extends Node2D

@onready var main_buttons: VBoxContainer = $CenterContainer/MainButtons
@onready var settings_menu: VBoxContainer = $CenterContainer/SettingsMenu
@onready var credits_menu: VBoxContainer = $CenterContainer/CreditsMenu
@onready var settings: Button = $CenterContainer/MainButtons/Settings
@onready var credits: Button = $CenterContainer/MainButtons/Credits
@onready var play: Button = $CenterContainer/MainButtons/Play
@onready var full_screen: CheckBox = $CenterContainer/SettingsMenu/FullScreen
@onready var main_volume: HSlider = $CenterContainer/SettingsMenu/MainVolume
@onready var music_volume: HSlider = $CenterContainer/SettingsMenu/MusicVolume

func _ready() -> void:
	full_screen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	main_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("MUSIC")))
	
func _on_play_pressed() -> void:
	SceneSwitcher.switch_scene("res://Management/game_level.tscn")

func _on_settings_pressed() -> void:
	main_buttons.visible = false
	settings_menu.visible = true
	
func _on_credits_pressed() -> void:
	main_buttons.visible = false
	credits_menu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	main_buttons.visible = true
	if credits_menu.visible:
		credits_menu.visible = false
	if settings_menu.visible:
		settings_menu.visible = false
		
func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

func _on_main_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
	
func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("MUSIC"), value)
