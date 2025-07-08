class_name Merchandise
extends Item

@export var sprite_2d: Sprite2D

var is_valid_placement: bool = true
var occupied_tiles: Array[Vector2i]

func set_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)
