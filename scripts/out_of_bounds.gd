extends Area2D

# Constants
const FATAL_FALL = true  # Set to false if you want to just take damage instead of instant death

# References
@onready var timer = null

func _ready() -> void:
	# Create timer for effects
	timer = Timer.new()
	timer.name = "EffectTimer"
	timer.one_shot = true
	timer.wait_time = 0.5
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	# Connect body entered signal if not already connected
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	print("Out of bounds area initialized")

func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding body is the player
	if body is Player:
		print("Player entered out of bounds area")
		
		if FATAL_FALL:
			# Direct game over approach - lose all remaining lives
			while GlobalData.lives > 0:
				GlobalData.lose_life()
			
			# Double check to enforce game over
			if GlobalData.lives <= 0:
				print("All lives lost, changing to game over scene")
				# Create a one-shot timer to delay scene change
				var scene_change_timer = Timer.new()
				scene_change_timer.name = "SceneChangeTimer"
				scene_change_timer.one_shot = true
				scene_change_timer.wait_time = 0.1
				add_child(scene_change_timer)
				scene_change_timer.timeout.connect(func():
					if get_tree() != null:
						get_tree().change_scene_to_file("res://gameover.tscn")
					scene_change_timer.queue_free()
				)
				scene_change_timer.start()
		else:
			# Just lose one life
			GlobalData.lose_life()
			
			# Provide visual feedback
			set_modulate(Color(1, 0, 0, 0.5))
			timer.start()
			
			# Reset player position if still alive
			if GlobalData.lives > 0:
				_reset_player_position(body)

func _on_timer_timeout() -> void:
	# Reset any visual effects
	set_modulate(Color(1, 1, 1, 1))

func _reset_player_position(player: Player) -> void:
	# Try to find spawn point in the level
	var spawn_point = get_tree().get_first_node_in_group("spawn_point")
	if spawn_point:
		player.global_position = spawn_point.global_position
	else:
		# Default respawn at a reasonable position if no spawn point is found
		player.global_position = Vector2(100, 100)

# Direct method for debugging - can be called from elsewhere
func force_game_over():
	print("Forcing game over scene change")
	# Create a one-shot timer to delay scene change for reliability
	var scene_change_timer = Timer.new()
	scene_change_timer.name = "SceneChangeTimer"
	scene_change_timer.one_shot = true
	scene_change_timer.wait_time = 0.1
	add_child(scene_change_timer)
	scene_change_timer.timeout.connect(func():
		if get_tree() != null:
			get_tree().change_scene_to_file("res://gameover.tscn")
		scene_change_timer.queue_free()
	)
	scene_change_timer.start()
