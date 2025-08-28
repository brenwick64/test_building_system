class_name RFurnitureSaveData
extends RSaveData

@export var packed_scene: PackedScene
@export var furniture_data: RItemData
@export var global_position: Vector2
@export var primary_tile: Vector2i
@export var occupied_tiles: Array[Vector2i]

static func pack_save_data(element) -> RFurnitureSaveData:
	var furniture: PlaceableFurniture = element as PlaceableFurniture
	if not furniture:
		push_error("Invalid type passed to PlaceableFurniture: " + str(element))
		return null
	var save_data: RFurnitureSaveData = RFurnitureSaveData.new()	
	var packed_scene: PackedScene = PackedScene.new()
	packed_scene.pack(furniture)
	save_data.packed_scene = packed_scene
	save_data.furniture_data = furniture.furniture_data
	save_data.global_position = furniture.global_position
	save_data.primary_tile = furniture.primary_tile
	save_data.occupied_tiles = furniture.occupied_tiles
	return save_data

static func unpack_save_data(save_data: RFurnitureSaveData) -> PlaceableFurniture:
	var furniture_ins: PlaceableFurniture = save_data.packed_scene.instantiate()
	furniture_ins.furniture_data = save_data.furniture_data
	furniture_ins.global_position = save_data.global_position
	furniture_ins.primary_tile = save_data.primary_tile
	furniture_ins.occupied_tiles = save_data.occupied_tiles
	return furniture_ins
