class_name BridgeAreaInteract
extends Area2D

@onready var water_interact: TileMapLayer = $"../../../TerrainManager/WaterInteract"

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		water_interact.collision_enabled = false


func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		water_interact.collision_enabled = true
