class_name RItemData
extends Resource

@export var item_id: String
@export var item_name: String

@export var icon_scale_multiplier: float = 1.0
@export var placeable_scale_multiplier: float = 1.0
@export var pickup_scale_multiplier: float = 1.0
@export var item_texture: Texture
@export var item_base_scene: PackedScene

@export var placeable_data: RPlaceable

## -- constructors --
func new_item_scene() -> Item:
	var item_ins: Node2D = item_base_scene.instantiate() as Item
	item_ins.scale = Vector2(placeable_scale_multiplier, placeable_scale_multiplier)
	return item_ins

func new_icon_scene() -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = item_texture
	texture_rect.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	# manual centering
	texture_rect.size = item_texture.get_size()
	texture_rect.position -= (texture_rect.size / 2) * icon_scale_multiplier
	texture_rect.scale = Vector2(icon_scale_multiplier, icon_scale_multiplier)
	return texture_rect

func new_pickup_scene(pickup_scene: PackedScene, start_pos: Vector2, end_pos: Vector2) -> Pickup:
	var pickup_ins: Pickup = pickup_scene.instantiate()
	var item_scene: Item = new_item_scene()
	item_scene.scale = item_scene.scale * Vector2(pickup_scale_multiplier, pickup_scale_multiplier)
	pickup_ins.start_pos = start_pos
	pickup_ins.end_pos = end_pos
	pickup_ins.item_id = item_id
	pickup_ins.add_child(item_scene)
	return pickup_ins
