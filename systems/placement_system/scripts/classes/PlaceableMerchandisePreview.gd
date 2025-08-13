class_name PlaceableMerchandisePreview
extends Node2D

@export var sprite: Sprite2D

var item_id: String
var is_valid_placement: bool = true

func _ready() -> void:
	sprite.modulate = Color(1, 1, 1, 0.5)
