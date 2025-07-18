class_name RItemData
extends Resource

@export var item_id: String
@export var item_name: String

@export var item_texture: Texture
@export var item_base_scene: PackedScene

@export var placeable_data: RPlaceable

## -- constructors --
func new_item_scene() -> Item:
	var item_ins: Node2D = item_base_scene.instantiate() as Item
	return item_ins

func new_icon_scene() -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = item_texture
	texture_rect.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	texture_rect.pivot_offset = item_texture.get_size()
	texture_rect.scale = Vector2(2, 2)
	return texture_rect

#func new_pickup_scene(start_pos: Vector2, end_pos: Vector2) -> Pickup:
	#pass
	#var pickup_ins: Pickup = item_pickup.instantiate()
	#pickup_ins.start_pos = start_pos
	#pickup_ins.end_pos = end_pos
	#pickup_ins.item_id = item_id
	#return pickup_ins
