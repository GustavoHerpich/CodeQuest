extends Node2D

signal animation_finished(anim_name)

@onready var wheel_sprite: Sprite2D = $WheelSprite

var total_frames := 7
var current_frame := 0
var target_frame_count := 0
var spin_timer := Timer.new()

func _ready():
	add_child(spin_timer)
	spin_timer.wait_time = 0.12
	spin_timer.one_shot = false
	spin_timer.timeout.connect(_on_spin_timer_timeout)
	wheel_sprite.frame = 0

func spin_wheel():
	current_frame = randi() % total_frames
	target_frame_count = total_frames + randi() % 10 

	wheel_sprite.frame = current_frame
	spin_timer.start()

func _on_spin_timer_timeout():
	current_frame = (current_frame + 1) % total_frames
	wheel_sprite.frame = current_frame
	target_frame_count -= 1

	if target_frame_count <= 0:
		spin_timer.stop()
		emit_signal("animation_finished", GameConstants.ANIM_ROTATE)
