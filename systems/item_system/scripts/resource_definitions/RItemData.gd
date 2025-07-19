class_name RItemData
extends Resource

@export var item_id: String
@export var item_name: String

@export var placeable_scale_multiplier: float = 1.0
@export var pickup_scale_multiplier: float = 1.0
@export var item_texture: Texture
@export var item_base_scene: PackedScene

@export var placeable: RPlaceableItem
@export var icon: RItemIcon

func init() -> void: # persists item_id to other resources dynamically
	if placeable:
		placeable.item_id = item_id

## -- constructors --
func new_item_scene() -> PlaceableItem:
	var item_ins: Node2D = item_base_scene.instantiate() as PlaceableItem
	item_ins.item_id = item_id
	item_ins.scale = Vector2(placeable_scale_multiplier, placeable_scale_multiplier)
	return item_ins

func new_pickup_scene(pickup_scene: PackedScene, start_pos: Vector2, end_pos: Vector2) -> Pickup:
	var pickup_ins: Pickup = pickup_scene.instantiate()
	var item_scene: PlaceableItem = new_item_scene()
	item_scene.scale = item_scene.scale * Vector2(pickup_scale_multiplier, pickup_scale_multiplier)
	pickup_ins.start_pos = start_pos
	pickup_ins.end_pos = end_pos
	pickup_ins.item_id = item_id
	pickup_ins.add_child(item_scene)
	return pickup_ins
