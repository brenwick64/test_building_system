extends Node2D

@export var pickup: Pickup
@export var start_pos:Vector2
@export var end_pos:Vector2
@export var travel_time:float = 0.5
@export var arc_peak_height:float = 15.0

signal arc_motion_finished

var _time_passed:float = 0.0
var _is_moving:bool = true

func _ready():
	position = start_pos

func _physics_process(delta):
	if not _is_moving:
		return

	_time_passed += delta
	var progress: float = clamp(_time_passed / travel_time, 0.0, 1.0)

	if progress >= 1.0:
		_is_moving = false
		arc_motion_finished.emit()

	var flat_position = start_pos.lerp(end_pos, progress)
	var vertical_offset = -sin(progress * PI) * arc_peak_height
	flat_position.y += vertical_offset

	pickup.position = flat_position
