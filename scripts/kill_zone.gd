# kill_zone.gd
extends Area2D

@onready var timer = $Timer

func _ready():
	# Initialize timer settings if needed for visual effects
	if timer:
		timer.one_shot = true
		timer.wait_time = 0.5  # Half second for potential effects
		timer.timeout.connect(_on_timer_timeout)
	else:
		# Create timer if it doesn't exist
		timer = Timer.new()
		timer.name = "Timer"
		timer.one_shot = true
		timer.wait_time = 0.5
		add_child(timer)
		timer.timeout.connect(_on_timer_timeout)
	
	# Connect signals if not already connected
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)

func _on_body_entered(body):
	if body is Player:
		body.take_damage(1, global_position)
		
		# Visual feedback
		set_modulate(Color(1, 0, 0, 1))  # Flash red
		timer.start()

func _on_timer_timeout():
	# Reset any visual effects
	set_modulate(Color(1, 1, 1, 1))  # Return to normal color

func _on_area_entered(area: Area2D):
	if area.get_parent() is Player:
		var player = area.get_parent()
		player.take_damage(1, global_position)
		
		# Visual feedback
		set_modulate(Color(1, 0, 0, 1))  # Flash red
		timer.start()
