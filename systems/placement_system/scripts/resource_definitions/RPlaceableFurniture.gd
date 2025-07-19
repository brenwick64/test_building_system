class_name RPlaceableFurniture
extends RPlaceableItem

#FIXME: This variable is required if a furniture has the same width and height
# and you wish to rotate it
@export var is_symmetrical: bool

@export var tile_matrix: Array[Vector2i]
@export var scene_horizontal: PackedScene
@export var scene_vertical: PackedScene

const ROTATION_VALUES: Array[int] = [0, 90]
var current_degrees: int = ROTATION_VALUES[0]

## -- constructors
func new_horizontal_scene() -> PlaceableFurniture:
	var horizontal_ins: Node2D = scene_horizontal.instantiate()
	horizontal_ins.item_id = item_id
	return horizontal_ins
	
func new_vertical_scene() -> PlaceableFurniture:
	var vertical_ins: Node2D = scene_vertical.instantiate()
	vertical_ins.item_id = item_id
	return vertical_ins

## -- methods --
func rotate_clockwise() -> void:
	var index: int = ROTATION_VALUES.find(current_degrees)
	index = (index + 1) % ROTATION_VALUES.size()
	current_degrees = ROTATION_VALUES[index]
	
func get_furniture() -> Node2D:
	match current_degrees:
		0: return new_horizontal_scene()
		90: return new_vertical_scene()
	push_error("error: current rotation degrees for " + resource_name + "is invalid: " + str(current_degrees))
	return new_horizontal_scene()

func get_tile_matrix() -> Array[Vector2i]:
	match current_degrees:
		0: return _get_rotated_tile_matrix(0)
		90: return _get_rotated_tile_matrix(90)
	push_error("error: current rotation degrees for " + resource_name + "is invalid: " + str(current_degrees))
	return _get_rotated_tile_matrix(0)
	
## -- helper functions --
#TODO: optimize / find actual formula
func _get_rotated_tile_matrix(degrees: int) -> Array[Vector2i]:
	var iterations: int = floor(degrees / 90)
	var new_matrix: Array[Vector2i] = tile_matrix.duplicate()
	for i: int in range(iterations):
		var cur_matrix: Array[Vector2i] = []
		for vector: Vector2i in new_matrix:
			if is_symmetrical:
				var clockwise_vector: Vector2i = Vector2i((vector.y * -1), (vector.x * -1))
				cur_matrix.append(clockwise_vector)
			else:
				var clockwise_vector: Vector2i = Vector2i(vector.y, (vector.x * -1))
				cur_matrix.append(clockwise_vector)
		new_matrix = cur_matrix
	return new_matrix
