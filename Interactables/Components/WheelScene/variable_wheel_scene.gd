class_name Wheel
extends Node2D

const QUESTIONS := [
	{
		"question": "Qual dessas é uma variável do tipo inteiro?",
		"options": ["\"42\"", "42", "\"true\""],
		"answer": 1
	},
	{
		"question": "Qual dessas é uma variável do tipo booleano?",
		"options": ["false", "\"false\"", "0"],
		"answer": 0
	},
	{
		"question": "Qual dessas representa uma string?",
		"options": ["\"Olá mundo\"", "123", "true"],
		"answer": 0
	},
	{
		"question": "Qual é um exemplo de número decimal?",
		"options": ["3.14", "\"3.14\"", "3"],
		"answer": 0
	},
	{
		"question": "Qual dessas não é uma variável válida?",
		"options": ["minha_variavel", "123abc", "_variavel"],
		"answer": 1
	}
]

var remaining_questions := QUESTIONS.duplicate()
var current_question := {}
var question_index := -1
var already_interacted: bool = false

@onready var wheel_node = $Wheel/WheelContainer/Wheel
@onready var wheel_container: Control = $Wheel/WheelContainer
@onready var click_area: Area2D = $Wheel/WheelContainer/Wheel/ClickArea
@onready var question_panel: CanvasLayer = $QuestionPanel
@onready var question_label: Label = $QuestionPanel/Panel/VBoxContainer/QuestionLabel
@onready var option_buttons := [
	$QuestionPanel/Panel/VBoxContainer/OptionsContainer/Option1Button,
	$QuestionPanel/Panel/VBoxContainer/OptionsContainer/Option2Button,
	$QuestionPanel/Panel/VBoxContainer/OptionsContainer/Option3Button
]
@onready var options_container: VBoxContainer = $QuestionPanel/Panel/VBoxContainer/OptionsContainer
@onready var feedback_label: Label = $QuestionPanel/Panel/VBoxContainer/FeedbackLabel

func _ready():
	add_to_group(GameConstants.GROUP_CONSOLE_INSTANCES)

	question_panel.visible = false
	wheel_container.visible = true
	feedback_label.visible = false

	for i in range(option_buttons.size()):
		option_buttons[i].pressed.connect(_on_option_selected.bind(i))

	click_area.connect("input_event", _on_click_area_input)
	wheel_node.connect("animation_finished", _on_animation_finished)

	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player and "enter_wheel" in player:
		player.enter_wheel()

	GameManager.update_mouse_visibility()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GameConstants.INPUT_EXIT):
		close()

func _on_click_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if remaining_questions.is_empty():
			show_final_feedback()
			return

		click_area.set_pickable(false)
		question_panel.visible = false

		wheel_node.spin_wheel()

func _on_animation_finished(anim_name: String):
	if anim_name == "rotate":
		pick_and_show_question()
		click_area.set_pickable(true)

func pick_and_show_question():
	if remaining_questions.is_empty():
		show_final_feedback()
		return

	question_index = randi() % remaining_questions.size()
	current_question = remaining_questions[question_index]
	remaining_questions.remove_at(question_index)

	show_question(current_question)

func show_question(q: Dictionary):
	question_label.text = q["question"]
	for i in range(option_buttons.size()):
		option_buttons[i].text = q["options"][i]
		option_buttons[i].disabled = false

	feedback_label.visible = false
	question_panel.visible = true
	wheel_container.visible = false

func _on_option_selected(selected_index: int):
	var correct_index = current_question["answer"]
	if selected_index == correct_index:
		feedback_label.text = "✅ Correto! Prepare-se para a próxima pergunta!"
		feedback_label.modulate = Color.GREEN
		for btn in option_buttons:
			btn.disabled = true
		feedback_label.visible = true

		await get_tree().create_timer(1.5).timeout
		question_panel.visible = false
		wheel_container.visible = true 

		if not remaining_questions.is_empty():
			wheel_node.spin_wheel()
		else:
			show_final_feedback()

	else:
		feedback_label.text = "❌ Resposta incorreta. Tente novamente."
		feedback_label.modulate = Color.RED
		feedback_label.visible = true

func _on_tree_exiting() -> void:
	var player = get_tree().get_first_node_in_group(GameConstants.GROUP_PLAYER)
	if player and "exit_wheel" in player:
		player.exit_wheel()

	for obj in get_tree().get_nodes_in_group(GameConstants.GROUP_INTERACTABLE_OBJECTS):
		if obj is Goblin:
			obj.has_interacted = false

	GameManager.update_mouse_visibility()

func show_final_feedback():
	question_panel.visible = true
	question_label.text = "🎉 Parabéns! Você acertou todas as perguntas!"
	for btn in option_buttons:
		btn.disabled = true
	feedback_label.text = ""
	click_area.set_pickable(false)
	wheel_container.visible = false
	
	already_interacted = true
	if not already_interacted:
		BookManager.add_book_page(
			"funcoes_objetos",
			"👤 Player",
			"🗡️ [code]increaseAttack(min, max)[/code]\nAumenta o dano mínimo e máximo do jogador.\n\nExemplo:\n[code]increaseAttack(2, 5)[/code]",
			"🔥 [code]attackRange()[/code]\nRetorna o intervalo de ataque atual do jogador como um Vector2 (mínimo, máximo).\n\nExemplo:\n[code]print(attackRange())  # Exemplo saída: (3, 10)[/code]"
		)

func close() -> void:
	self.visible = false
	queue_free()
