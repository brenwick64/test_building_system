class_name PlaceableFurniturePreview
extends Node2D

# node dependencies
@export var base_scene: PlaceableBase
@export var placement_area: Area2D

var item_id: String
var furniture_data: RItemData
var is_valid_placement: bool = true

func _ready() -> void:
	base_scene.sprite.modulate = Color(1, 1, 1, 0.5)
	placement_area.area_entered.connect(_on_placement_area_entered)
	placement_area.area_exited.connect(_on_placement_area_exited)

## -- methods --
func set_invalid_placement() -> void:
	base_scene.sprite.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false
	
func set_valid_placement() -> void:
	base_scene.sprite.modulate = Color(1.0, 1.0, 1.0, 0.5)
	is_valid_placement = true

## -- signals --
func _on_placement_area_entered(_area: Area2D) -> void:
	set_invalid_placement()

func _on_placement_area_exited(_area: Area2D) -> void:
	set_valid_placement()
