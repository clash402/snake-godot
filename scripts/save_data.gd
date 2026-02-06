extends RefCounted
class_name SaveData

const SAVE_PATH := "user://save_data.json"

static func load_best_score() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		return 0

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return 0

	var raw := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(raw)
	if parsed is Dictionary:
		var data: Dictionary = parsed
		if data.has("best_score"):
			return maxi(0, int(data["best_score"]))

	return 0


static func save_best_score(value: int) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	var payload := {"best_score": maxi(0, value)}
	file.store_string(JSON.stringify(payload))
	file.close()
