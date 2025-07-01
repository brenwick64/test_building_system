class_name TileManager
extends Node

signal new_tile_hovered(tile_coords: Vector2i)
signal layer_mouse_out

@export var layer: TileMapLayer

var current_hovered_tile_coords: Vector2i

## -- public methods --
func get_tile_coords_from_gp(global_pos: Vector2) -> Vector2i:
	return layer.local_to_map(global_pos)

func get_gp_from_tile_coords(tile_coords: Vector2i) -> Vector2i:
	return layer.to_global(layer.map_to_local(tile_coords)) 

## -- helper functions --
func _get_hovered_tile_coords() -> Vector2i:
	var mouse_pos_local: Vector2 = layer.get_local_mouse_position()
	var tile_coords: Vector2i = layer.local_to_map(mouse_pos_local)
	return tile_coords
	
func _process(_delta: float) -> void:
	var tile_coords: Vector2i = _get_hovered_tile_coords()
	var tile_data: TileData = layer.get_cell_tile_data(tile_coords)
	if not tile_data: # wrong tile layer 
		current_hovered_tile_coords = Vector2i.ZERO
		layer_mouse_out.emit()
		return 
	# new tile hovered
	if tile_coords != current_hovered_tile_coords:
		new_tile_hovered.emit(tile_coords)
		current_hovered_tile_coords = tile_coords
