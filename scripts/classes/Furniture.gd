class_name Furniture
extends Node

@export var tile_matrix: Array[Vector2i]
@export var sprite_2d: Sprite2D

func configure_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
