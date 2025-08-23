class_name RMerchandiseSaveData
extends RSaveData

@export var packed_scene: PackedScene
@export var item_data: RItemData
@export var rotation: float
@export var tile_coords: Vector2i

static func get_resource_instance(
	packed_scene: PackedScene,
	item_data: RItemData,
	rotation: float, 
	tile_coords: Vector2i
	) -> RMerchandiseSaveData:
	var ins: RMerchandiseSaveData = RMerchandiseSaveData.new()
	ins.packed_scene = packed_scene
	ins.item_data = item_data
	ins.rotation = rotation
	ins.tile_coords = tile_coords
	return ins
