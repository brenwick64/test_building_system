class_name RMerchandise
extends RItem

@export var is_rotatable: bool
@export var base_value: float
@export var item_slot_matrix: Array[Vector2i]
@export var item_dimensions: Vector2i

var is_rotated: bool = false
var is_flipped: bool = false

## -- methods --
func get_rotation_deg() -> int:
	var rotation_deg: int = 0
	if is_rotated: rotation_deg += 90
	if is_flipped: rotation_deg += 180
	return rotation_deg

func rotate_clockwise() -> void:
	if not is_rotatable: return
	if is_rotated: return # only supports a single rotation
	_rotate_item_slot_matrix("clockwise")
	_invert_item_dimensions()
	is_rotated = true
	
func rotate_counter_clockwise() -> void:
	if not is_rotatable: return
	if not is_rotated: return # only supports a single rotation
	_rotate_item_slot_matrix("counter_clockwise")
	_invert_item_dimensions()
	is_rotated = false
 
func flip() -> void:
	is_flipped = not is_flipped

## -- helper functions --
func _rotate_item_slot_matrix(direction: String) -> void:
	var new_matrix: Array[Vector2i] = []
	for vector: Vector2i in item_slot_matrix:
		if direction == "clockwise":
			new_matrix.append(Vector2i(vector.y, (vector.x * -1)))
		elif direction == "counter_clockwise":
			new_matrix.append(Vector2i(Vector2i((vector.y * -1), vector.x)))
	item_slot_matrix = new_matrix

func _invert_item_dimensions() -> void:
	item_dimensions = Vector2i(item_dimensions.y, item_dimensions.x)
