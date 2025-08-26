class_name RFurnitureSaveData
extends RSaveData

@export var packed_scene: PackedScene
@export var item_data: RItemData
@export var global_pos: Vector2
@export var primary_tile: Vector2i
@export var occupied_tiles: Array[Vector2i]

static func new_resource_instance(
	p_packed_scene: PackedScene,
	p_item_data: RItemData,
	p_global_pos: Vector2,
	p_primary_tile: Vector2i,
	p_occupied_tiles: Array[Vector2i]
	) -> RFurnitureSaveData:
	var ins: RFurnitureSaveData = RFurnitureSaveData.new()
	ins.packed_scene = p_packed_scene
	ins.item_data = p_item_data
	ins.global_pos = p_global_pos
	ins.primary_tile = p_primary_tile
	ins.occupied_tiles = p_occupied_tiles
	return ins
