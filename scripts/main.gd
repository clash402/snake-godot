extends Control

enum GameState {
	TITLE,
	PLAYING,
	GAME_OVER,
}

const TITLE_SCENE := preload("res://scenes/Title.tscn")
const GAME_SCENE := preload("res://scenes/Game.tscn")
const GAME_OVER_SCENE := preload("res://scenes/GameOver.tscn")

var state: GameState = GameState.TITLE
var best_score: int = 0
var last_score: int = 0
var current_screen: Control

@onready var screen_root: Control = $ScreenRoot


func _ready() -> void:
	best_score = SaveData.load_best_score()
	show_title()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		if state == GameState.PLAYING or state == GameState.GAME_OVER:
			start_game()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("menu"):
		if state != GameState.TITLE:
			show_title()
			get_viewport().set_input_as_handled()


func show_title() -> void:
	state = GameState.TITLE
	var title := TITLE_SCENE.instantiate() as Control
	_swap_screen(title)

	var best_label := title.get_node("Center/VBox/BestLabel") as Label
	best_label.text = "Best: %d" % best_score

	var play_button := title.get_node("Center/VBox/PlayButton") as Button
	play_button.pressed.connect(_on_play_pressed)

	var quit_button := title.get_node("Center/VBox/QuitButton") as Button
	if OS.has_feature("web"):
		quit_button.visible = false
		quit_button.disabled = true
	else:
		quit_button.visible = true
		quit_button.disabled = false
		quit_button.pressed.connect(_on_quit_pressed)


func start_game() -> void:
	state = GameState.PLAYING
	var game := GAME_SCENE.instantiate() as SnakeGame
	_swap_screen(game)
	game.game_over.connect(_on_game_over)
	game.best_score_changed.connect(_on_best_score_changed)
	game.start_new_game(best_score)


func show_game_over(score: int, best: int) -> void:
	state = GameState.GAME_OVER
	var game_over := GAME_OVER_SCENE.instantiate() as Control
	_swap_screen(game_over)

	var score_label := game_over.get_node("Center/VBox/ScoreLabel") as Label
	score_label.text = "Score: %d" % score

	var best_label := game_over.get_node("Center/VBox/BestLabel") as Label
	best_label.text = "Best: %d" % best

	var restart_button := game_over.get_node("Center/VBox/RestartButton") as Button
	restart_button.pressed.connect(_on_restart_pressed)

	var menu_button := game_over.get_node("Center/VBox/MenuButton") as Button
	menu_button.pressed.connect(_on_menu_pressed)


func _swap_screen(new_screen: Control) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = new_screen
	screen_root.add_child(current_screen)


func _on_play_pressed() -> void:
	start_game()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	start_game()


func _on_menu_pressed() -> void:
	show_title()


func _on_game_over(score: int, best: int) -> void:
	last_score = score
	if best > best_score:
		best_score = best
		SaveData.save_best_score(best_score)
	show_game_over(last_score, best_score)


func _on_best_score_changed(new_best: int) -> void:
	if new_best > best_score:
		best_score = new_best
		SaveData.save_best_score(best_score)
