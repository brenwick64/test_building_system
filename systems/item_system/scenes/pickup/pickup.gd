class_name Pickup
extends Node2D

@export var pickup_area: Area2D
@export var pickup_delay: Timer
@export var arc_move_on_spawn: Node2D

@export var item_id: String

var start_pos: Vector2
var end_pos: Vector2

func _ready():
	arc_move_on_spawn.start_pos = start_pos
	arc_move_on_spawn.end_pos = end_pos
	arc_move_on_spawn.arc_motion_finished.connect(_on_arc_move_on_spawn_arc_motion_finished)
	pickup_delay.timeout.connect(_on_pickup_delay_timeout)
	pickup_area.area_entered.connect(_on_pickup_area_area_entered)
	pickup_area.monitoring = false

# step 1 - trigger pickup delay after spawn animation
func _on_arc_move_on_spawn_arc_motion_finished():
	pickup_delay.start()

# step 2 - enable collisions after pickup delay
func _on_pickup_delay_timeout():
	pickup_area.monitoring = true

# step 3 - send item info to inventory manager
func _on_pickup_area_area_entered(area):
	var parent: Node2D = area.get_parent()
	if parent is Player:
		parent.inventory.add_item(item_id, 1)
	queue_free()
