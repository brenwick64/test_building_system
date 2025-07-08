class_name Furniture
extends Node

@export var sprite_2d: Sprite2D

var is_valid_placement: bool = true
var occupied_tiles: Array[Vector2i]
var items: Array[Item]

## -- methods --
func invalid_placement() -> void:
	sprite_2d.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false

func set_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)

func set_occupied_tiles(tile_matrix:Array[Vector2i], primary_tile_coords: Vector2i) -> void:
	for coords: Vector2i in tile_matrix:
		occupied_tiles.append(coords + primary_tile_coords)

func add_item(item: Item) -> void:
	pass
