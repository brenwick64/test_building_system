class_name RMerchandiseSaveData
extends RSaveData

@export var packed_scene: PackedScene
@export var item_data: RItemData
@export var rotation: float
@export var tile_coords: Vector2i

static func get_resource_instance(
	p_packed_scene: PackedScene,
	p_item_data: RItemData,
	p_rotation: float, 
	p_tile_coords: Vector2i
	) -> RMerchandiseSaveData:
	var ins: RMerchandiseSaveData = RMerchandiseSaveData.new()
	ins.packed_scene = p_packed_scene
	ins.item_data = p_item_data
	ins.rotation = p_rotation
	ins.tile_coords = p_tile_coords
	return ins
