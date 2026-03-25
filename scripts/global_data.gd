# global_data.gd
extends Node

const SAVE_FILE = "user://game_progress.save"

var levels: Array = []
var unlockedLevels: int = 3 
var character: String = ""
var player_name: String = ""
var max_lives: int = 3  # Maximum of 3 hearts total
var lives: int = max_lives
var hud: CanvasLayer = null

# Level completion tracking
var level1_completed: bool = false
var level2_completed: bool = false
var level3_completed: bool = false

func _ready():
	load_saved_progress()
	if hud == null:
		hud = get_node_or_null("/root/Hud")

func lose_life():
	lives -= 1
	if hud:
		hud.load_hearts()
	if lives <= 0:
		get_tree().change_scene_to_file("res://gameover.tscn")
	else:
		print("Lives remaining: ", lives)

func save_progress():
	var save_dict = {
		"level1_completed": level1_completed,
		"level2_completed": level2_completed,
		"level3_completed": level3_completed,
		"unlockedLevels": unlockedLevels,
		"player_name": player_name,
		"character": character
	}
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))

func load_saved_progress():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		var json_string = file.get_as_text()
		var data = JSON.parse_string(json_string)
		if data:
			level1_completed = data.get("level1_completed", false)
			level2_completed = data.get("level2_completed", false)
			level3_completed = data.get("level3_completed", false)
			unlockedLevels = data.get("unlockedLevels", 3)
			player_name = data.get("player_name", "")
			character = data.get("character", "")

func complete_level(level_number: int) -> void:
	match level_number:
		1:
			level1_completed = true
		2:
			level2_completed = true
		3:
			level3_completed = true
	save_progress()

func reset_lives() -> void:
	lives = max_lives
	if hud:
		hud.load_hearts()

func reset_level_progress() -> void:
	level1_completed = false
	level2_completed = false
	level3_completed = false
	unlockedLevels = 3
	save_progress()
	
	var current_scene = get_tree().current_scene
	if current_scene and current_scene.has_method("update_button_states"):
		current_scene.update_button_states()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_progress()
		get_tree().quit()
