class_name RFurniture
extends Resource

@export var tile_matrix: Array[Vector2i]
@export var scene_0: PackedScene
@export var scene_90: PackedScene
@export var scene_180: PackedScene
@export var scene_270: PackedScene

const ROTATION_VALUES: Array[int] = [0, 90, 180, 270]
var current_degrees: int = ROTATION_VALUES[0]

func _update_tile_matrix_clockwise() -> void:
	var new_matrix: Array[Vector2i] = []
	for vector: Vector2i in tile_matrix:
		var clockwise_vector: Vector2i = Vector2i((vector.y * -1), vector.x)
		new_matrix.append(clockwise_vector)
	tile_matrix = new_matrix

func get_furniture() -> PackedScene:
	match current_degrees:
		0: return scene_0
		90: return scene_90
		180: return scene_180
		270: return scene_270
	push_error("error: current rotation degrees for " + resource_name + "is invalid: " + str(current_degrees))
	return scene_0

func rotate_clockwise() -> void:
	var index: int = ROTATION_VALUES.find(current_degrees)
	index = (index + 1) % ROTATION_VALUES.size()
	current_degrees = ROTATION_VALUES[index]
	_update_tile_matrix_clockwise()
