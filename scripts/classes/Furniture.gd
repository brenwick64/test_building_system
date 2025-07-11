class_name Furniture
extends Node

@export var sprite_2d: Sprite2D
@export var item_slots: Node2D
@export var item_slot_matrix: Array[Vector2i]

var is_valid_placement: bool = true
var occupied_tiles: Array[Vector2i]

## -- helper functions --
func _get_free_furniture_coords() -> Array[Vector2i]:
	var occupied: Array[Vector2i] = []
	for slot in item_slots.get_children():
		if slot.placed_item:
			occupied += slot.item_matrix
	var free_slots: Array[Vector2i] = item_slot_matrix.filter(func(v): return v not in occupied)
	return free_slots
	
func _get_hovered_slots(tile_coords: Vector2i) -> Array[Node2D]:
	var hovered_slots: Array[Node2D] = []
	var normalized_coords: Vector2i = tile_coords - occupied_tiles[0] # pivot tile
	for slot in item_slots.get_children():
		if normalized_coords in slot.item_matrix:
			hovered_slots.append(slot)
	return hovered_slots

func _match_item_with_slot(item: RMerchandise, hovered_slots: Array[Node2D]) -> Node2D:
	for slot: Node2D in hovered_slots:
		if slot.slot_dimensions == item.item_dimensions:
			return slot
	return null

func get_free_item_slot(item: RMerchandise, tile_coords: Vector2i) -> Node2D:
	var free_coords = _get_free_furniture_coords()
	if not free_coords: return
	var hovered_slots = _get_hovered_slots(tile_coords)
	if not hovered_slots: return
	var matched_slot = _match_item_with_slot(item, hovered_slots)
	if not matched_slot: return
	if matched_slot.placed_item: return
	return matched_slot

## -- methods --
func invalid_placement() -> void:
	sprite_2d.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false

func set_preview() -> void:
	sprite_2d.modulate = Color(1, 1, 1, 0.5)

func set_occupied_tiles(tile_matrix:Array[Vector2i], primary_tile_coords: Vector2i) -> void:
	for coords: Vector2i in tile_matrix:
		occupied_tiles.append(coords + primary_tile_coords)

#TODO: encapsulate variable logic here instead of merch_manager
func add_item(item: Item) -> void:
	pass
	
	
