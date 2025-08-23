class_name RFurnitureSaveData
extends RSaveData

@export var packed_scene: PackedScene
@export var item_data: RItemData
@export var global_pos: Vector2
@export var primary_tile: Vector2i
@export var occupied_tiles: Array[Vector2i]

static func new_resource_instance(
		packed_scene: PackedScene,
		item_data: RItemData,
		global_pos: Vector2,
		primary_tile: Vector2i,
		occupied_tiles: Array[Vector2i]) -> RFurnitureSaveData:
	var ins: RFurnitureSaveData = RFurnitureSaveData.new()
	ins.packed_scene = packed_scene
	ins.item_data = item_data
	ins.global_pos = global_pos
	ins.primary_tile = primary_tile
	ins.occupied_tiles = occupied_tiles
	return ins
