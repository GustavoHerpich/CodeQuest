## Classe responsável por gerar e gerenciar o puzzle de labirinto.
## Geração aleatória: sem caminho pré-soluível exposto ao jogador.

class_name MazePuzzle
extends Node2D

## Emite um sinal quando o puzzle é resolvido corretamente.
signal puzzle_solved

const WALKABLE := 1
const BLOCKED := 0

@export var size: Vector2i = Vector2i(15, 6)
@export var desired_walkable_ratio: float = 0.33 # proporção de células walkable (0..1)

var maze: Array = []
var movement_queue: Array[Vector2i] = []
var is_moving: bool = false

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var game_object_register := GameObject.new()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

## Inicialização do labirinto e registro do RNG
func _ready() -> void:
	rng.randomize()
	add_child(game_object_register)
	_initialize_maze()
	_build_visual_maze()

## Cria a matriz do labirinto com células aleatórias walkable ou blocked
func _initialize_maze() -> void:
	maze.clear()
	for y in range(size.y):
		var row_cells: Array = []
		for x in range(size.x):
			var cell_type := WALKABLE if rng.randf() < desired_walkable_ratio else BLOCKED
			row_cells.append(cell_type)
		maze.append(row_cells)

## Gera um caminho mínimo do início ao fim (0,0 até size-1), embaralhando movimentos
func _generate_minimal_path() -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	for i in range(size.x - 1):
		moves.append(Vector2i(1, 0)) # direita
	for i in range(size.y - 1):
		moves.append(Vector2i(0, 1)) # baixo

	_shuffle_array(moves)

	var path: Array[Vector2i] = []
	var current_pos: Vector2i = Vector2i(0, 0)
	path.append(current_pos)
	for move_step in moves:
		current_pos += move_step
		path.append(current_pos)
	return path

## Embaralha um array usando Fisher-Yates controlado pelo RNG da instância
func _shuffle_array(array_to_shuffle: Array) -> void:
	var n: int = array_to_shuffle.size()
	for i in range(n):
		var j: int = rng.randi_range(i, n - 1)
		var tmp: Variant = array_to_shuffle[i]
		array_to_shuffle[i] = array_to_shuffle[j]
		array_to_shuffle[j] = tmp

## Cria a representação visual do labirinto usando TileMapLayer
func _build_visual_maze() -> void:
	tile_map_layer.clear()

	var visual_cells: Array = []
	for y in range(size.y):
		for x in range(size.x):
			var tile_type := 0 if maze[y][x] == WALKABLE else 1
			visual_cells.append([Vector2i(x, y), tile_type])

	for cell_data in visual_cells:
		tile_map_layer.set_cell(cell_data[0], cell_data[1], Vector2i(0, 0))

# ----------------------------
# Animações / Efeitos auxiliares
# ----------------------------

## Processa a fila de movimentos animando deslocamento das células
func _process_movement_queue() -> void:
	if movement_queue.is_empty():
		is_moving = false
		return

	is_moving = true
	var movement_offset_vec: Vector2i = movement_queue.pop_front()
	var movement_offset: Vector2 = Vector2(movement_offset_vec.x, movement_offset_vec.y) * 64

	var tween := get_tree().create_tween()
	tween.tween_property(tile_map_layer, "position", tile_map_layer.position + movement_offset, 0.5)
	tween.finished.connect(_process_movement_queue)

## Alterna visual de uma célula (walkable / blocked) com efeito de fade
func _toggle_cell_visual(x: int, y: int) -> void:
	var tile_type := 0 if maze[y][x] == WALKABLE else 1
	tile_map_layer.set_cell(Vector2i(x, y), tile_type, Vector2i(0, 0))

	var tween := get_tree().create_tween()
	tile_map_layer.modulate = Color(1, 1, 1, 0)
	tween.tween_property(tile_map_layer, "modulate", Color(1, 1, 1, 1), 0.3)

# ----------------------------
# DFS para verificação de caminho
# ----------------------------

## Função recursiva para determinar se existe caminho da posição atual até o destino
func _dfs(pos: Vector2i, visited_cells: Array) -> bool:
	if pos.x < 0 or pos.x >= size.x or pos.y < 0 or pos.y >= size.y:
		return false
	if maze[pos.y][pos.x] == BLOCKED:
		return false
	if visited_cells[pos.y][pos.x]:
		return false

	if pos == Vector2i(size.x - 1, size.y - 1):
		return true

	visited_cells[pos.y][pos.x] = true

	return (
		_dfs(pos + Vector2i(1, 0), visited_cells) or
		_dfs(pos + Vector2i(-1, 0), visited_cells) or
		_dfs(pos + Vector2i(0, 1), visited_cells) or
		_dfs(pos + Vector2i(0, -1), visited_cells)
	)

# ----------------------------
# Integração com Console
# ----------------------------

## Imprime o labirinto no console (walkable = '.', blocked = '#')
func printMaze() -> void:
	var buffer_str := ""
	for row_cells in maze:
		for cell_value in row_cells:
			buffer_str += ("." if cell_value == WALKABLE else "#") + " "
		buffer_str += "\n"
	GameManager.print(buffer_str)

## Alterna o estado de uma célula entre walkable e blocked
func toggleCell(x: int, y: int) -> void:
	if x >= 0 and x < size.x and y >= 0 and y < size.y:
		maze[y][x] = BLOCKED if maze[y][x] == WALKABLE else WALKABLE
		_toggle_cell_visual(x, y)

## Verifica se há um caminho do início ao fim do labirinto
func solveMaze() -> void:
	maze[0][0] = WALKABLE
	maze[size.y - 1][size.x - 1] = WALKABLE

	var visited_cells: Array = []
	for y in range(size.y):
		var row_visited: Array = []
		for x in range(size.x):
			row_visited.append(false)
		visited_cells.append(row_visited)

	var path_exists := _dfs(Vector2i(0, 0), visited_cells)
	if path_exists:
		GameManager.print("✅ Existe um caminho!")
		emit_signal("puzzle_solved")

		BookManager.add_book_page(
			"fim_da_jornada",
			"🔮 O Último Comando",
			"[code]endGame()[/code]\n\nNão há descrição...\nApenas uma sensação de conclusão e de algo maior além.",
			"Talvez este comando pertença ao próprio mundo que o envolve...\nAo que mantém tudo em ordem... ou ao que pode encerrá-lo."
		)
	else:
		GameManager.error("❌ Nenhum caminho encontrado.")
