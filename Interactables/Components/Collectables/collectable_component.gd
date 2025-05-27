extends Area2D
class_name CollectableComponent

@onready var sound_effect: AudioStreamPlayer = $SoundEffect

func _ready():
	sound_effect.connect("finished", Callable(self, "_on_sound_finished"))

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		visible = false
		sound_effect.play()

func _on_sound_finished():
	queue_free()
