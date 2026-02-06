extends RefCounted
class_name GameConfig

const GRID_WIDTH: int = 20
const GRID_HEIGHT: int = 20
const CELL_SIZE: int = 24

const START_LENGTH: int = 3
const START_TICK: float = 0.15
const SPEED_RAMP_EVERY: int = 5
const SPEED_MULTIPLIER: float = 0.92
const MIN_TICK: float = 0.06

const WRAP_AROUND: bool = false

const HUD_HEIGHT: int = 64
const WINDOW_WIDTH: int = GRID_WIDTH * CELL_SIZE
const WINDOW_HEIGHT: int = HUD_HEIGHT + (GRID_HEIGHT * CELL_SIZE)

const BG_COLOR := Color(0.05, 0.07, 0.11, 1.0)
const HUD_PANEL_COLOR := Color(0.08, 0.11, 0.16, 1.0)
const HUD_TEXT_COLOR := Color(0.93, 0.95, 0.98, 1.0)
const BOARD_COLOR := Color(0.10, 0.13, 0.18, 1.0)
const GRID_LINE_COLOR := Color(0.16, 0.20, 0.27, 1.0)
const SNAKE_HEAD_COLOR := Color(0.45, 0.87, 0.35, 1.0)
const SNAKE_BODY_COLOR := Color(0.30, 0.74, 0.26, 1.0)
const FOOD_COLOR := Color(0.95, 0.28, 0.34, 1.0)
