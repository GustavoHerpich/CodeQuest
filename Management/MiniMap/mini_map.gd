## Classe que representa o minimapa do jogo.
## Responsável por renderizar uma visão reduzida da cena principal,
## centralizando a câmera no jogador e sincronizando o SubViewport
## com o mundo do jogo.

extends CanvasLayer

@onready var sub_viewport: SubViewport = $UI/MarginContainer/SubViewportContainer/SubViewport
@onready var mini_map_camera: Camera2D = sub_viewport.get_node("MiniMapCamera")

var player_node: Node2D

## Configuração inicial do minimapa.
## Sincroniza o SubViewport com o mesmo mundo 2D da cena principal.
func _ready() -> void:
	sub_viewport.world_2d = get_viewport().world_2d

## Atualiza a posição da câmera do minimapa a cada frame de física,
## garantindo que ela siga a posição global do jogador.
func _physics_process(_delta: float) -> void:
	mini_map_camera.global_position = player_node.global_position
