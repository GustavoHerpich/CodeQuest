class_name BridgeAreaInteract
extends Area2D

@onready var water_interact: TileMapLayer = $"../../../TerrainManager/WaterInteract"

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		water_interact.collision_enabled = false

func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		water_interact.collision_enabled = true

func _on_area_entered(_area: Area2D) -> void:
	GameManager.print("✅ Ponte alinhada! Você pode atravessar.")
	BookManager.add_book_page(
		"funcoes_objetos",
		"🚪 Porta",
		"📋 [code]getDoorValues()[/code]\nRetorna lista de valores da porta.\n\n🔎 [code]showPassword(valor)[/code]\nMostra a senha se o valor estiver correto.",
		"🗝️ [code]openDoor(senha)[/code]\nTenta abrir a porta com a senha.\n\nExemplo:\n[code]showPassword(4)[/code]"
	)
		
	BookManager.add_book_page(
		"como_programar",
		"🔄 Estruturas de Controle",
		"[b]🔁 Repetição (for):[/b]\n[code]for i = 1, 5 do\n  print(i)\nend[/code]",
		"[b]🔀 Condicional (if):[/b]\n[code]if x > 0 then\n  print(\"Positivo\")\nend[/code]"
	)
