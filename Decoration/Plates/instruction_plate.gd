# InstructionPlate.gd
extends Node2D

@export var plate_text: String = ""
@onready var label: Label = $Label

func _ready():
	label.text = plate_text

func set_text(new_text: String) -> void:
	label.text = new_text
