class_name TileManager
extends Node

#@export var navigatable_layers: Array[TileMapLayer]
@export var tilemap_layer: TileMapLayer

var occupied_tiles: Array[Vector2i] = []

## -- methods --
func sort_closest_tiles(tiles: Array[Vector2i], global_pos: Vector2) -> Array[Vector2i]:
	tiles.sort_custom(func(a: Vector2i, b: Vector2i): 
		return get_global_pos_from_tile(a).distance_to(global_pos) < get_global_pos_from_tile(b).distance_to(global_pos))
	return tiles

func get_navigatable_neighboring_tiles(tiles: Array[Vector2i]) -> Array[Vector2i]:
	var navigatable_tiles = [] as Array[Vector2i]
	var surrounding_tiles: Array[Vector2i] = _get_surrounding_tiles(tiles)
	var unoccupied_tiles: Array[Vector2i] = _get_unoccupied_tiles(surrounding_tiles)
	for tile_coords: Vector2i in unoccupied_tiles:
		# checks if tile is in the correct  layer
		var tile_data: TileData = tilemap_layer.get_cell_tile_data(tile_coords)
		if tile_data:
			# checks if tile is navigatable
			var nav_polygon: NavigationPolygon = tile_data.get_navigation_polygon(0)
			if nav_polygon:
				navigatable_tiles.append(tile_coords)
	return navigatable_tiles

func get_tile_from_global_pos(global_position: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap_layer.to_local(global_position)
	var tile_coords: Vector2i = tilemap_layer.local_to_map(local_pos)
	return tile_coords

func get_global_pos_from_tile(tile_coords: Vector2i) -> Vector2:
	var local_pos: Vector2 = tilemap_layer.map_to_local(tile_coords)
	var global_pos: Vector2 = tilemap_layer.to_global(local_pos)
	return global_pos

## -- function override handlers --
func should_strip_nav(coords: Vector2i) -> bool:
	if coords in occupied_tiles: return true # placed furniture
	if _is_orphan_tile(coords): return true # semi-isolated (no NSEW neighbors) tile
	return false

func strip_nav(tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)

## -- helper functions --
func _is_orphan_tile(coords: Vector2i ) -> bool:
	var surrounding_tiles: Array[Vector2i] =  get_navigatable_neighboring_tiles([coords])
	var tile_offsets: Array[Vector2i] = [
		Vector2i(0,1), # north
		Vector2i(0,1), # south
		Vector2i(1,0), # east
		Vector2i(-1,0) # west
	]
	for offset: Vector2i in tile_offsets:
		var offset_coords: Vector2i = coords + offset
		if offset_coords in surrounding_tiles:
			return false
	return true

func _get_unoccupied_tiles(tiles: Array[Vector2i]) -> Array[Vector2i]:
	return tiles.filter(func(tile: Vector2i): return not tile in occupied_tiles)

func _get_surrounding_tiles(tile_coords: Array[Vector2i]) -> Array[Vector2i]:
	var surrounding_tiles = [] as Array[Vector2i]
	
	# Offsets for the 8 neighbors around a cell
	var tile_offsets: Array[Vector2i] = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1,  0),                  Vector2i(1,  0),
		Vector2i(-1,  1), Vector2i(0,  1), Vector2i(1,  1),
	]
	# includes the "box" of tiles around each tile
	for coords: Vector2i in tile_coords:
		for offset: Vector2i in tile_offsets:
			var new_coords: Vector2i = coords + offset
			# only add new tiles to avoid duplicates
			if new_coords not in surrounding_tiles:
				surrounding_tiles.append(coords + offset)
			
	# remove any overlap
	surrounding_tiles = surrounding_tiles.filter(
		func(coords: Vector2i): return coords not in tile_coords
	)
	return surrounding_tiles

## -- signals --
func _on_placement_manager_placed_furniture_updated(placed_furniture: Array[PlaceableFurniture]) -> void:
	var new_occupied_tiles: Array[Vector2i] = []
	for furniture: PlaceableFurniture in placed_furniture:
		new_occupied_tiles += furniture.occupied_tiles
	occupied_tiles = new_occupied_tiles
	tilemap_layer.notify_runtime_tile_data_update()
