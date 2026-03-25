extends Area2D

signal level1_completed

func _ready():
	# Connect the level completion signal
	level1_completed.connect(_on_level1_completed)

func _on_direct_pressed() -> void:
	$button.play()
	await $button.finished
	# Emit the level completion signal before changing scene
	level1_completed.emit()
	GlobalData.level1_completed = true
	
	# Save progress
	var save_dict = {
		"level1_completed": true,
		"level2_completed": GlobalData.level2_completed
	}
	var file = FileAccess.open("user://game_progress.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	
	# Change to the proceed scene
	get_tree().change_scene_to_file("res://UI/proceed.tscn")

func _on_level1_completed():
	# You can add additional completion effects here
	# Like particles, sounds, or animations
	pass
