class_name Furniture
extends Node

@export var tile_matrix: Array[Vector2i]
@export var sprite_2d: Sprite2D

var is_valid_placement: bool = true
var occupied_tiles: Array[Vector2i]

func invalid_placement() -> void:
	sprite_2d.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false

func configure_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)

func configure_furniture(primary_tile_coords: Vector2i) -> void:
	for coords: Vector2i in tile_matrix:
		occupied_tiles.append(coords + primary_tile_coords)
	sprite_2d.modulate = Color(1, 1, 1, 1)
