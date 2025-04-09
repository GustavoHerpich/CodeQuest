extends RichTextLabel

@onready var rich_text_label: RichTextLabel = $"."

func _ready():
	rich_text_label.clear()
	rich_text_label.append_bbcode("""
[b][center]Seu Jogo[/center][/b]
[i]Um jogo educativo feito para ensinar lógica de programação[/i]

[b]📚 Sobre o Projeto[/b]
Este jogo foi desenvolvido como parte do TCC do curso de Análise e Desenvolvimento de Sistemas...

[b]👨‍💻 Desenvolvido por[/b]
Seu Nome

[b]🔗 GitHub[/b]
[url=https://github.com/seuusuario]github.com/seuusuario[/url]

[b]🎮 Feito com[/b]
Godot Engine 4.4
Lua
DialogueManager 3

[b]🧠 Agradecimentos[/b]
- Professor Fulano
- Amigos testers
- Comunidade Godot
""")
