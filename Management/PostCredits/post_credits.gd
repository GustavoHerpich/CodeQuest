extends Control

@onready var credits: RichTextLabel = $RichTextLabel
@onready var background: ColorRect = $ColorRect

func _ready():
	background.size = get_viewport_rect().size

	credits.set_anchors_preset(Control.PRESET_FULL_RECT)
	credits.clear()
	credits.append_text("""
[center][b]✨ Fim da Jornada ✨[/b][/center]

[center][i]Você chegou ao fim... mas esta aventura não foi apenas sobre um jogo.[/i][/center]

[center][b]📚 Sobre o Projeto[/b][/center]
[center]Este projeto foi desenvolvido como Trabalho de Conclusão de Curso em
Análise e Desenvolvimento de Sistemas no IFRS – Campus Farroupilha.[/center]

[center]Seu propósito foi transformar o aprendizado de lógica e programação
em uma experiência interativa, divertida e desafiadora.[/center]

[center]Ao longo desta jornada, você aprendeu conceitos como:[/center]
[center]- Estruturas de decisão[/center]
[center]- Laços de repetição[/center]
[center]- Funções e modularidade[/center]
[center]- Organização lógica de problemas[/center]

[center][b]👨‍💻 Desenvolvimento[/b][/center]
[center]- Gustavo Herpich — programação, design e concepção do jogo[/center]
[center]- Gabriel — colaboração essencial no desenvolvimento da extensão Lua ↔ Godot[/center]

[center][b]🙏 Agradecimentos[/b][/center]
[center]- Aos professores e colegas do IFRS[/center]
[center]- À comunidade Godot e open source[/center]
[center]- Aos amigos que testaram e deram feedback[/center]
[center]- E a você, jogador, por dedicar seu tempo a explorar este mundo[/center]

[center][i]Este é o fim de CodeQuest...[/i][/center]
[center][i]... mas talvez apenas o começo da sua própria jornada como programador.[/i][/center]
""")

	var viewport_size = get_viewport_rect().size
	credits.position = Vector2(
		(viewport_size.x - credits.size.x) / 2,
		viewport_size.y
	)

	var tween = create_tween()
	tween.tween_property(background, "color:a", 1.0, 3.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	var target_y = -credits.get_content_height() - 100
	tween.tween_property(
		credits, "position:y",
		target_y,
		40.0
	)

	tween.finished.connect(_on_credits_finished)

func _on_credits_finished():
	get_tree().change_scene_to_file("res://Management/MainMenu/main_menu.tscn")
