# health_pickup.gd
extends Node2D

@onready var area_2d = $Area2D
@onready var animated_sprite = $Area2D/AnimatedSprite2D

func _ready() -> void:
	# Check if the animated sprite exists
	if animated_sprite:
		# Get available animations
		var animations = animated_sprite.sprite_frames.get_animation_names()
		if animations.size() > 0:
			# Play the first available animation
			animated_sprite.play(animations[0])
			print("Playing health pickup animation: ", animations[0])
		else:
			push_error("No animations found in health pickup AnimatedSprite2D")
	else:
		push_error("AnimatedSprite2D not found at path: $Area2D/AnimatedSprite2D")
	
	# Connect the body_entered signal
	if area_2d:
		if not area_2d.body_entered.is_connected(_on_body_entered):
			area_2d.body_entered.connect(_on_body_entered)
			print("Connected health pickup area signal")
	else:
		push_error("Area2D not found at path: $Area2D")

func _on_body_entered(body: Node2D) -> void:
	print("Body entered health pickup: ", body.name)
	
	# Check if the body is a Player instance
	if body is Player:
		# Try to add a heart
		if body.add_heart():
			print("Heart added! Current hearts: ", body.get_current_hearts())
			queue_free()
		else:
			print("Player already at max hearts: ", body.get_current_hearts())
