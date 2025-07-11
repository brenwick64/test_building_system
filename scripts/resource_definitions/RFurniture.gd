class_name RFurniture
extends RItem

@export var tile_matrix: Array[Vector2i]
@export var scene_horizontal: PackedScene
@export var scene_vertical: PackedScene

const ROTATION_VALUES: Array[int] = [0, 90]
var current_degrees: int = ROTATION_VALUES[0]

## -- methods --
func rotate_clockwise() -> void:
	var index: int = ROTATION_VALUES.find(current_degrees)
	index = (index + 1) % ROTATION_VALUES.size()
	current_degrees = ROTATION_VALUES[index]
	
func get_furniture() -> PackedScene:
	match current_degrees:
		0: return scene_vertical
		90: return scene_horizontal
	push_error("error: current rotation degrees for " + resource_name + "is invalid: " + str(current_degrees))
	return scene_horizontal

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
			var clockwise_vector: Vector2i = Vector2i(vector.y, (vector.x * -1))
			cur_matrix.append(clockwise_vector)
		new_matrix = cur_matrix
	return new_matrix
