class_name MazePuzzle
extends Node2D

signal puzzle_solved

const WALKABLE := 1
const BLOCKED := 0

var size: Vector2i = Vector2i(15, 6)
var maze: Array = []  
var movement_queue: Array[Vector2i] = []
var is_moving := false

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var game_object_register := GameObject.new()

# Private methods

func _ready() -> void:
	add_child(game_object_register)
	_initialize_maze()
	_build_visual_maze()

func _initialize_maze() -> void:
	var has_path := false
	while not has_path:
		maze.clear()
		var total := size.x * size.y
		var walkable_count := total / 2

		var values: Array = []
		for i in range(walkable_count):
			values.append(WALKABLE)
		for i in range(total - walkable_count):
			values.append(BLOCKED)

		values.shuffle()

		for y in range(size.y):
			var row: Array = []
			for x in range(size.x):
				row.append(values.pop_back())
			maze.append(row)

		var visited: Array = []
		for y in range(size.y):
			visited.append([])
			for x in range(size.x):
				visited[y].append(false)
		has_path = _dfs(Vector2i(0, 0), visited)

func _build_visual_maze() -> void:
	tile_map_layer.clear()
	for y in range(size.y):
		for x in range(size.x):
			var source_id := 0 if maze[y][x] == WALKABLE else 1
			tile_map_layer.set_cell(Vector2i(x, y), source_id, Vector2i(0, 0))

func _process_movement_queue() -> void:
	if movement_queue.is_empty():
		is_moving = false
		return

	is_moving = true
	var offset: Vector2i = movement_queue.pop_front()
	var movement_offset: Vector2 = Vector2(offset.x, offset.y) * 64  

	var tween := get_tree().create_tween()
	tween.tween_property(tile_map_layer, "position", tile_map_layer.position + movement_offset, 0.5)
	tween.finished.connect(_process_movement_queue)

func _toggle_cell_visual(x: int, y: int) -> void:
	var tile_id := 0 if maze[y][x] == WALKABLE else 1
	var tween := get_tree().create_tween()

	tile_map_layer.set_cell(Vector2i(x, y), tile_id, Vector2i(0, 0))

	tile_map_layer.set_cell(Vector2i(x, y), tile_id, Vector2i(0, 0))
	tile_map_layer.set_cell(Vector2i(x, y), tile_id, Vector2i(0, 0)) 
	tile_map_layer.set_cell(Vector2i(x, y), tile_id, Vector2i(0, 0))

	tile_map_layer.modulate = Color(1,1,1,0)
	tween.tween_property(tile_map_layer, "modulate", Color(1,1,1,1), 0.3)


func _dfs(pos: Vector2i, visited: Array) -> bool:
	if pos.x < 0 or pos.x >= size.x or pos.y < 0 or pos.y >= size.y:
		return false
	if maze[pos.y][pos.x] == BLOCKED:
		return false
	if visited[pos.y][pos.x]:
		return false

	if pos == Vector2i(size.x - 1, size.y - 1):
		return true

	visited[pos.y][pos.x] = true

	return (
		_dfs(pos + Vector2i(1, 0), visited) or
		_dfs(pos + Vector2i(-1, 0), visited) or
		_dfs(pos + Vector2i(0, 1), visited) or
		_dfs(pos + Vector2i(0, -1), visited)
	)

## Methods that interact with the console

func printMaze() -> void:
	for row in maze:
		var line := ""
		for cell in row:
			line += ("." if cell == WALKABLE else "#") + " "
		GameManager.print(line)
		
func toggleCell(x: int, y: int) -> void:
	if x >= 0 and x < size.x and y >= 0 and y < size.y:
		maze[y][x] = BLOCKED if maze[y][x] == WALKABLE else WALKABLE
		_toggle_cell_visual(x, y)

func solveMaze() -> bool:
	var visited: Array = []
	for y in range(size.y):
		var row: Array = []
		for x in range(size.x):
			row.append(false)
		visited.append(row)

	var result := _dfs(Vector2i(0, 0), visited)
	if result:
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
	return result
