extends CharacterBody2D

@export var move_speed: float = 120.0
@export var acceleration: float = 1000.0 

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: String = "down"

func _ready() -> void:
	pass

## -- helper functions --
func _get_movement_vector() -> Vector2:
	# Handles cases of digital and analog player inputs (keyboard = digital, controller = analog)
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement).normalized()
	
func _get_direction_name(direction: Vector2) -> String:
	if abs(direction.x) > abs(direction.y):
		return "right" if direction.x > 0 else "left"
	else:
		return "down" if direction.y > 0 else "up"

func _play_animation(direction: Vector2) -> void:
	animated_sprite_2d.flip_h = false
	if direction == Vector2.ZERO:
		if last_direction == "left":
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("idle_right")
		else:
			animated_sprite_2d.play("idle_" + last_direction)
		return
	var dir_name: String = _get_direction_name(direction)
	if dir_name == "left":
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("move_right")
	else:
		animated_sprite_2d.play("move_" + dir_name)
	last_direction = dir_name

func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = _get_movement_vector()
	_play_animation(input_direction)
	
	var target_velocity: Vector2 = input_direction * move_speed
	velocity = velocity.move_toward(target_velocity, acceleration * delta)
	move_and_slide()
