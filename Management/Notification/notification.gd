## Classe responsável por exibir notificações na tela.
##
## AutoLoad (NotificationManager)
## As notificações são exibidas em fila (queue) e processadas uma a uma.
## Cada mensagem aparece com animação, som e desaparece após alguns segundos.
## 
## Funcionalidades:
## - Adicionar mensagens na fila.
## - Exibir animação de entrada e saída.
## - Reproduzir som de notificação.
## - Garantir que múltiplas mensagens não se sobreponham.
extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/Label
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sound: AudioStreamPlayer = $NotifictionSound

var message_queue: Array[String] = []
var is_showing := false

## Processa a fila de mensagens e exibe a próxima disponível.
func _process_queue() -> void:
	if message_queue.is_empty():
		is_showing = false
		visible = false
		return
	
	is_showing = true
	label.text = message_queue.pop_front()
	visible = true
	
	anim.play("show")
	sound.play()
	await anim.animation_finished
	await get_tree().create_timer(3.0).timeout
	anim.play("hide")
	await anim.animation_finished
	
	_process_queue()
	
## Adiciona uma nova mensagem à fila de notificações.
## @param msg Texto da notificação.
func show_message(msg: String) -> void:
	message_queue.append(msg)
	if not is_showing:
		_process_queue()
