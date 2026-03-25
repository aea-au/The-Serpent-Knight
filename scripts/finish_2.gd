extends Area2D

signal level2_completed

func _ready():
	# Connect the level completion signal
	level2_completed.connect(_on_level2_completed)

func _on_direct_2_pressed() -> void:
	$button.play()
	await $button.finished
	# Emit the level completion signal before changing scene
	level2_completed.emit()
	GlobalData.level2_completed = true
	
	# Save progress
	var save_dict = {
		"level1_completed": GlobalData.level1_completed,
		"level2_completed": true
	}
	var file = FileAccess.open("user://game_progress.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	
	# Change to the proceed scene
	get_tree().change_scene_to_file("res://UI/proceed_2.tscn")

func _on_level2_completed():
	# You can add additional completion effects here
	# Like particles, sounds, or animations
	pass
