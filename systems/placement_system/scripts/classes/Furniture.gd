class_name Furniture
extends Item

@export var is_horizontal: bool
@export var item_slots: Node2D
@export var item_slot_matrix: Array[Vector2i]
	
var is_valid_placement: bool = true
var occupied_tiles: Array[Vector2i]

## -- methods --
func set_invalid_placement() -> void:
	sprite_2d.modulate = Color(0.941176, 0.501961, 0.501961, 0.5)
	is_valid_placement = false

func set_occupied_tiles(tile_matrix:Array[Vector2i], primary_tile_coords: Vector2i) -> void:
	for coords: Vector2i in tile_matrix:
		occupied_tiles.append(coords + primary_tile_coords)

func get_free_item_slot(item: RItemData, tile_coords: Vector2i) -> Node2D:
	var hovered_slots: Array[Node2D] = _get_hovered_slots(tile_coords) # gets all slots in hovered tile
	if not hovered_slots: return
	var valid_slots: Array[Node2D] = _get_valid_slots(hovered_slots) # gets all slots that are 100% free
	if not valid_slots: return
	var matched_slot = _get_matched_slot(item.placeable_data, valid_slots) # gets slot that matches item dimension
	if not matched_slot: return
	if matched_slot.placed_item: return
	return matched_slot

func get_occupied_slot_at_coords(tile_coords: Vector2i) -> Node2D:
	var hovered_slots: Array[Node2D] = _get_hovered_slots(tile_coords) # gets all slots in hovered tile
	if not hovered_slots: return
	for slot: Node2D in hovered_slots:
		if slot.placed_item:
			return slot
	return null

## -- helper functions --
func _get_unoccupied_matrix() -> Array[Vector2i]:
	var occupied: Array[Vector2i] = []
	for slot in item_slots.get_children():
		if slot.placed_item:
			occupied += slot.item_matrix
	var free_coords: Array[Vector2i] = item_slot_matrix.filter(func(v): return v not in occupied)
	return free_coords

func _get_hovered_slots(tile_coords: Vector2i) -> Array[Node2D]:
	var hovered_slots: Array[Node2D] = []
	var normalized_coords: Vector2i = tile_coords - occupied_tiles[0] # pivot tile
	for slot in item_slots.get_children():
		if normalized_coords in slot.item_matrix:
			hovered_slots.append(slot)
	return hovered_slots

func _get_valid_slots(slots: Array[Node2D]) -> Array[Node2D]:
	var valid_slots: Array[Node2D] = []
	for slot in slots:
		var is_valid: bool = slot.item_matrix.all(func(v): return v in _get_unoccupied_matrix())
		if is_valid:
			valid_slots.append(slot)
	return valid_slots

func _get_matched_slot(item: RPlaceableMerchandise, hovered_slots: Array[Node2D]) -> Node2D:
	if not is_horizontal and not item.is_rotated: item.rotate_clockwise()
	if is_horizontal and item.is_rotated: item.rotate_counter_clockwise()
	for slot: Node2D in hovered_slots:
		if item.item_dimensions == slot.slot_dimensions:
			return slot
	return null

func _rotate_item(item: RPlaceableMerchandise) -> void:
	if item.is_rotated:
		item.rotate_counter_clockwise()
	else:
		item.rotate_clockwise()
