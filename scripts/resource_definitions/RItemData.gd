class_name RItemData
extends Resource

@export var item_id: String
@export var item_name: String
@export var item_scene: PackedScene
@export var item_icon: PackedScene
@export var item_pickup: PackedScene

## -- constructors --
func new_scene() -> Node2D:
	var item_ins: Node2D = item_scene.instantiate()
	item_ins.item_id = item_id
	return item_ins

func new_icon() -> TextureRect:
	var icon_ins: TextureRect = item_icon.instantiate()
	return icon_ins

func new_pickup(start_pos: Vector2, end_pos: Vector2) -> Pickup:
	var pickup_ins: Pickup = item_pickup.instantiate()
	pickup_ins.start_pos = start_pos
	pickup_ins.end_pos = end_pos
	pickup_ins.item_id = item_id
	return pickup_ins
