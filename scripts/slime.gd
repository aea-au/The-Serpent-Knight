extends Node2D

# Movement constants
const SPEED = 70

# Movement direction (-1 for left, 1 for right)
var direction = -1
var health = 1
var is_dead = false  # Variable to track death state

# Node references
@onready var ray_cast_right = $"RayCast right"
@onready var ray_cast_left = $"RayCast left"
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var kill_zone = $kill_zone

func _ready():
	# Ensure the kill zone is ready to detect collisions
	if not kill_zone.area_entered.is_connected(_on_kill_zone_area_entered):
		kill_zone.area_entered.connect(_on_kill_zone_area_entered)

func _process(delta):
	# Prevent movement and animation updates if dead
	if is_dead:
		return

	# Check for edge detection and change direction
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	# Move the enemy
	position.x += direction * SPEED * delta

func die():
	if is_dead:
		return  # Prevent multiple calls to die()

	is_dead = true  # Set death state

	# Disable collision and kill zone to stop damaging the player
	collision_shape.set_deferred("disabled", true)  
	kill_zone.set_deferred("monitoring", false)  # Stop detecting player

	set_physics_process(false)  # Stop further movement

	# Play death animation
	animated_sprite.play("death")

	# Wait for animation to finish, then remove the enemy
	await animated_sprite.animation_finished
	queue_free()  # Remove enemy from the scene

func _on_kill_zone_area_entered(area: Area2D):
	# Only apply damage if the enemy is not dead
	if is_dead:
		return

	# Check if the colliding area belongs to a player
	var player = area.get_parent()
	if player is Player:
		player.take_damage(1, global_position)

func _on_getdamagebox_body_entered(body: Node2D) -> void:
	if body is Player:
		health -= 1
		if health <= 0:
			die()


func _on_animated_sprite_2d_animation_finished() -> void:
	pass # Replace with function body.
