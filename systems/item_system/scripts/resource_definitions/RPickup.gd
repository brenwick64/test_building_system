class_name RPickup
extends Resource

var item_id: String

@export var pickup_scene: PackedScene
@export var pickup_scale_multiplier: float = 1.0

func new_pickup_scene(start_pos: Vector2, end_pos: Vector2) -> Pickup:
	var pickup_ins: Pickup = pickup_scene.instantiate()
	pickup_ins.item_id = item_id
	pickup_ins.start_pos = start_pos
	pickup_ins.end_pos = end_pos
	pickup_ins.scale = Vector2(pickup_scale_multiplier, pickup_scale_multiplier)
	return pickup_ins
