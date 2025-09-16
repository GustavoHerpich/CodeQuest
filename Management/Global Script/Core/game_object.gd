## Essa classe registra automaticamente o nó pai (objeto interativo)
## no GameManager ao entrar na árvore. Usado para permitir que o terminal
## chame funções deste objeto via Lua.

class_name GameObject
extends Node

func _ready():
	GameManager.register_object(get_parent())
