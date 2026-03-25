extends Node2D

func _ready():
	update_button_states()

func _exit_tree():
	$musicforchoices.stop()

func update_button_states():
	var level2_button = $"level 2"
	var level3_button = $"level 3"
	var reset_button = $"reset_progress"  # New reset button reference
	
	if level2_button:
		level2_button.disabled = not GlobalData.level1_completed
		level2_button.modulate = Color(1, 1, 1) if GlobalData.level1_completed else Color(0.5, 0.5, 0.5)
	
	if level3_button:
		level3_button.disabled = not (GlobalData.level1_completed and GlobalData.level2_completed)
		level3_button.modulate = Color(1, 1, 1) if (GlobalData.level1_completed and GlobalData.level2_completed) else Color(0.5, 0.5, 0.5)

func _on_level_1_pressed() -> void:
	$button.play()
	await $button.finished
	GlobalData.reset_lives()
	get_tree().change_scene_to_file("res://FOREST.tscn")

func _on_level_2_pressed() -> void:
	$button.play()
	await $button.finished
	if GlobalData.level1_completed:
		GlobalData.reset_lives()
		get_tree().change_scene_to_file("res://mountains.tscn")

func _on_level_3_pressed() -> void:
	$button.play()
	await $button.finished
	if GlobalData.level1_completed and GlobalData.level2_completed:
		GlobalData.reset_lives()
		get_tree().change_scene_to_file("res://cave.tscn")

	

# New function to handle reset progress button press
func _on_reset_progress_pressed() -> void:
	$button.play()
	await $button.finished
	var confirm_dialog = ConfirmationDialog.new()
	add_child(confirm_dialog)
	
	confirm_dialog.title = "Reset Progress"
	confirm_dialog.dialog_text = "Are you sure you want to reset all level progress? This cannot be undone."
	confirm_dialog.get_ok_button().text = "Reset"
	confirm_dialog.get_cancel_button().text = "Cancel"
	
	# Connect dialog signals
	confirm_dialog.confirmed.connect(_do_reset_progress)
	confirm_dialog.canceled.connect(_on_reset_canceled.bind(confirm_dialog))
	
	# Show dialog
	confirm_dialog.popup_centered()

# Function to actually perform the reset
func _do_reset_progress() -> void:
	GlobalData.reset_level_progress()
	update_button_states()

# Cleanup function for the dialog
func _on_reset_canceled(dialog: ConfirmationDialog) -> void:
	dialog.queue_free()


func _on_back_pressed() -> void:
	$button.play()
	await $button.finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
