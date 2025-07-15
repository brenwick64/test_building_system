class_name Pickup
extends Node2D

## behaviors
@export var arc_move_on_spawn: Node2D
## collisions
@export var pickup_collision: CollisionShape2D
## timers
@export var pickup_delay: Timer

var item_id: String
var start_pos: Vector2
var end_pos: Vector2

func _ready():
	arc_move_on_spawn.start_pos = start_pos
	arc_move_on_spawn.end_pos = end_pos

# step 1 - trigger pickup delay after spawn animation
func _on_arc_move_on_spawn_arc_motion_finished():
	pickup_delay.start()

# step 2 - enable collisions after pickup delay
func _on_pickup_delay_timeout():
	pickup_collision.disabled = false

# step 3 -send item info to inventory manager
func _on_pickup_area_area_entered(area):
	print(area)
	queue_free()
