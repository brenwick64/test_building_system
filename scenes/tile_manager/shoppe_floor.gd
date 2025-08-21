extends TileMapLayer

@export var tile_manager: TileManager

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return tile_manager.should_strip_nav(coords)

func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_manager.strip_nav(tile_data)
