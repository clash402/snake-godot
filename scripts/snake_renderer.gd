extends Node2D
class_name SnakeRenderer

var snake: Array[Vector2i] = []
var food: Vector2i = Vector2i.ZERO


func set_state(new_snake: Array[Vector2i], new_food: Vector2i) -> void:
	snake = new_snake.duplicate()
	food = new_food
	queue_redraw()


func _draw() -> void:
	var board_size := Vector2(GameConfig.GRID_WIDTH * GameConfig.CELL_SIZE, GameConfig.GRID_HEIGHT * GameConfig.CELL_SIZE)
	draw_rect(Rect2(Vector2.ZERO, board_size), GameConfig.BOARD_COLOR, true)

	for x in range(GameConfig.GRID_WIDTH + 1):
		var line_x := float(x * GameConfig.CELL_SIZE)
		draw_line(Vector2(line_x, 0.0), Vector2(line_x, board_size.y), GameConfig.GRID_LINE_COLOR, 1.0)

	for y in range(GameConfig.GRID_HEIGHT + 1):
		var line_y := float(y * GameConfig.CELL_SIZE)
		draw_line(Vector2(0.0, line_y), Vector2(board_size.x, line_y), GameConfig.GRID_LINE_COLOR, 1.0)

	_draw_cell(food, GameConfig.FOOD_COLOR)

	for i in range(snake.size()):
		var color := GameConfig.SNAKE_HEAD_COLOR if i == 0 else GameConfig.SNAKE_BODY_COLOR
		_draw_cell(snake[i], color)


func _draw_cell(cell: Vector2i, color: Color) -> void:
	var inset := 2.0
	var cell_position := Vector2(cell.x * GameConfig.CELL_SIZE, cell.y * GameConfig.CELL_SIZE)
	var size := Vector2(GameConfig.CELL_SIZE, GameConfig.CELL_SIZE)
	var rect := Rect2(cell_position + Vector2(inset, inset), size - Vector2(inset * 2.0, inset * 2.0))
	draw_rect(rect, color, true)
