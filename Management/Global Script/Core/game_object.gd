class_name GameObject
extends Node

## Este script registra automaticamente o nó pai (objeto interativo)
## no GameManager ao entrar na árvore. Usado para permitir que o terminal
## chame funções deste objeto via Lua.

func _ready():
	GameManager.register_object(get_parent())
