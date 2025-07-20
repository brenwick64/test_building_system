class_name RPlaceableItem
extends Resource

@export var placeable_scene: PackedScene
@export var placeable_scale_multiplier: float = 1.0

var item_id: String

## -- constructor --
func new_placeable_scene() -> PlaceableItem:
	var placeable_ins: Node2D = placeable_scene.instantiate() as PlaceableItem
	placeable_ins.item_id = item_id
	placeable_ins.scale = Vector2(placeable_scale_multiplier, placeable_scale_multiplier)
	return placeable_ins
