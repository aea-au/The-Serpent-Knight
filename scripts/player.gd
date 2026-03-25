# player.gd
extends CharacterBody2D
class_name Player  

# Movement Constants
const SPEED = 115.0
const JUMP_VELOCITY = -240.0
const GRAVITY = 980.0

# Combat System
const KNOCKBACK_FORCE = Vector2(300, -200)
const INVINCIBILITY_TIME = 0.5

# Jump Control
var jump_count = 0

# Invincibility
var is_invincible = false

# Node References
@onready var animated_sprite = $AnimatedSprite2D
@onready var sfx_jump_start = $sfx_jump_start
@onready var hurt_timer = $HurtTimer
@onready var collision_shape = $CollisionShape2D
@export var attacking = false 


func _ready():
	# Initialize hurt timer
	hurt_timer.one_shot = true
	hurt_timer.wait_time = INVINCIBILITY_TIME
	# Connect the hurt timer timeout signal
	if not hurt_timer.timeout.is_connected(_on_hurt_timer_timeout):
		hurt_timer.timeout.connect(_on_hurt_timer_timeout)

func _process(delta: float) -> void:
	if  Input.is_action_just_pressed("attack"):
		attack()
	
func _physics_process(delta):
		
	if not is_on_floor(): 
		velocity.y += GRAVITY * delta
	else:
		jump_count = 0

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and jump_count < 1: 
		jump_count += 1 
		velocity.y = JUMP_VELOCITY
		sfx_jump_start.play()

	# Get movement input
	var direction = Input.get_axis("ui_left", "ui_right")

	# Handle sprite flipping and animations
	if direction > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("walk")
	elif direction < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

	# Apply horizontal movement
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	
	


func attack():
	attacking = true 
	animated_sprite.play("Attack")
	
func take_damage(damage_amount: int, enemy_position: Vector2):
	if is_invincible:
		return
		
	# Use GlobalData lives system directly
	GlobalData.lose_life()
	
	# Calculate knockback direction
	var knockback_direction = Vector2(
		sign(global_position.x - enemy_position.x),  # Knock away from enemy
		1  # Upward component
	)
	
	# Apply knockback
	velocity = KNOCKBACK_FORCE * knockback_direction
	
	# Start invincibility
	start_invincibility()

func start_invincibility():
	is_invincible = true
	animated_sprite.modulate.a = 0.5  # Make semi-transparent
	hurt_timer.start()

func _on_hurt_timer_timeout():
	is_invincible = false
	animated_sprite.modulate.a = 1.0  # Return to full opacity

# Method to get current hearts (for UI purposes)
func get_current_hearts() -> int:
	return GlobalData.lives

# Method to add a heart
func add_heart() -> bool:
	if GlobalData.lives < GlobalData.max_lives:
		GlobalData.lives += 1
		if GlobalData.hud:
			GlobalData.hud.load_hearts()
		return true
	return false

# Emergency testing function - can call this to force game over
func _input(event):
	if event.is_action_pressed("ui_cancel") and Input.is_key_pressed(KEY_SHIFT):
		print("Emergency game over test")
		get_tree().change_scene_to_file("res://gameover.tscn")

func _on_sword_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):  # Check if the object hit is an enemy
		if body.has_method("die"):  # Ensure enemy has a death function
			body.die()  # Instantly kill the enemy
