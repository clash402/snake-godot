extends Control
class_name SnakeGame

signal game_over(score: int, best: int)
signal best_score_changed(best: int)

var rng := RandomNumberGenerator.new()
var snake: Array[Vector2i] = []
var current_dir: Vector2i = Vector2i.RIGHT
var queued_dir: Vector2i = Vector2i.RIGHT
var food: Vector2i = Vector2i.ZERO

var score: int = 0
var best_score: int = 0
var food_eaten: int = 0

var tick_interval: float = GameConfig.START_TICK
var accumulator: float = 0.0

@onready var score_label: Label = $ScoreLabel
@onready var best_label: Label = $BestLabel
@onready var renderer: SnakeRenderer = $SnakeRenderer
@onready var eat_sfx: AudioStreamPlayer = $EatSfx
@onready var death_sfx: AudioStreamPlayer = $DeathSfx


func _ready() -> void:
	set_process(false)


func start_new_game(initial_best: int) -> void:
	best_score = initial_best
	score = 0
	food_eaten = 0
	tick_interval = GameConfig.START_TICK
	accumulator = 0.0
	rng.randomize()

	var start_x := int(GameConfig.GRID_WIDTH / 2)
	var start_y := int(GameConfig.GRID_HEIGHT / 2)
	snake.clear()
	for i in range(GameConfig.START_LENGTH):
		snake.append(Vector2i(start_x - i, start_y))

	current_dir = Vector2i.RIGHT
	queued_dir = current_dir
	spawn_food()

	_update_hud()
	renderer.set_state(snake, food)
	set_process(true)
	grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		_queue_direction(Vector2i.UP)
	elif event.is_action_pressed("ui_down"):
		_queue_direction(Vector2i.DOWN)
	elif event.is_action_pressed("ui_left"):
		_queue_direction(Vector2i.LEFT)
	elif event.is_action_pressed("ui_right"):
		_queue_direction(Vector2i.RIGHT)


func _process(delta: float) -> void:
	accumulator += delta
	while accumulator >= tick_interval:
		accumulator -= tick_interval
		if not _step_snake():
			return


func _queue_direction(candidate: Vector2i) -> void:
	if _is_opposite(candidate, current_dir):
		return
	queued_dir = candidate


func _step_snake() -> bool:
	if not _is_opposite(queued_dir, current_dir):
		current_dir = queued_dir

	var next_head := snake[0] + current_dir
	if GameConfig.WRAP_AROUND:
		next_head = _wrap_position(next_head)
	elif _is_out_of_bounds(next_head):
		_trigger_game_over()
		return false

	var will_grow := next_head == food
	if _hits_snake(next_head, will_grow):
		_trigger_game_over()
		return false

	snake.push_front(next_head)
	if will_grow:
		score += 1
		food_eaten += 1
		if score > best_score:
			best_score = score
			best_score_changed.emit(best_score)

		if food_eaten % GameConfig.SPEED_RAMP_EVERY == 0:
			tick_interval = max(GameConfig.MIN_TICK, tick_interval * GameConfig.SPEED_MULTIPLIER)

		spawn_food()
		_play_if_available(eat_sfx)
	else:
		snake.pop_back()

	_update_hud()
	renderer.set_state(snake, food)
	return true


func _hits_snake(cell: Vector2i, will_grow: bool) -> bool:
	var count_to_check := snake.size()
	if not will_grow:
		count_to_check -= 1

	for i in range(count_to_check):
		if snake[i] == cell:
			return true
	return false


func _is_out_of_bounds(cell: Vector2i) -> bool:
	return cell.x < 0 or cell.y < 0 or cell.x >= GameConfig.GRID_WIDTH or cell.y >= GameConfig.GRID_HEIGHT


func _wrap_position(cell: Vector2i) -> Vector2i:
	var wrapped_x := ((cell.x % GameConfig.GRID_WIDTH) + GameConfig.GRID_WIDTH) % GameConfig.GRID_WIDTH
	var wrapped_y := ((cell.y % GameConfig.GRID_HEIGHT) + GameConfig.GRID_HEIGHT) % GameConfig.GRID_HEIGHT
	return Vector2i(wrapped_x, wrapped_y)


func _is_opposite(a: Vector2i, b: Vector2i) -> bool:
	return a + b == Vector2i.ZERO


func spawn_food() -> void:
	var open_cells: Array[Vector2i] = []
	for y in range(GameConfig.GRID_HEIGHT):
		for x in range(GameConfig.GRID_WIDTH):
			var cell := Vector2i(x, y)
			if not snake.has(cell):
				open_cells.append(cell)

	if open_cells.is_empty():
		food = snake[0]
		return

	food = open_cells[rng.randi_range(0, open_cells.size() - 1)]


func _trigger_game_over() -> void:
	set_process(false)
	_play_if_available(death_sfx)
	game_over.emit(score, best_score)


func _update_hud() -> void:
	score_label.text = "Score: %d" % score
	best_label.text = "Best: %d" % best_score


func _play_if_available(player: AudioStreamPlayer) -> void:
	if player != null and player.stream != null:
		player.play()
