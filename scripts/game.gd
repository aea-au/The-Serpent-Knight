extends Node2D


@onready var sfx_death_start = $sfx_death_start
@onready var audio_player = $AudioStreamPlayer  # Assuming you have an AudioStreamPlayer node

var current_level = 1  # Start at level 1

# This function is triggered when the restart button is pressed
func _on_button_pressed() -> void:
	# Stop audio before changing scene
	audio_player.stop()
	
	# Change scene based on the current level
	if current_level == 1:
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	elif current_level == 2:
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")
	elif current_level == 3:
		get_tree().change_scene_to_file("res://scenes/level_3.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/game.tscn")  # Default to "game" scene if no level is set

# Stop the audio when exiting the scene
func _exit_tree():
	audio_player.stop()  # Stop the audio when the scene is removed

	
