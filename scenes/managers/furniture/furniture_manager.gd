class_name FurnitureManager
extends Node

@export var input_manager: InputManager
@export var tile_manager: TileManager

@export var equipped_furniture: RFurniture
var furniture_preview: Furniture
var hovered_tile_coords: Vector2i
var placed_furniture: Array[Furniture]

## -- methods --
func get_furniture_at_coords(tile_coords: Vector2i) -> Furniture:
	for furniture: Furniture in placed_furniture:
		if tile_coords in furniture.occupied_tiles:
			return furniture
	return null

## -- overrides --
func _ready() -> void:
	input_manager.action_pressed.connect(_on_action_pressed)
	input_manager.rotate_pressed.connect(_on_rotate_pressed)
	tile_manager.new_tile_hovered.connect(_on_new_tile_hovered)
	tile_manager.layer_mouse_out.connect(_on_layer_mouse_out)

## -- helper functions --
func _is_used_tile() -> bool:
	for vector in equipped_furniture.tile_matrix:
		var preview_tile_coords: Vector2i = hovered_tile_coords + vector
		for furniture: Furniture in placed_furniture:
			if preview_tile_coords in furniture.occupied_tiles: 
				return true
	return false

func _is_incorrect_layer() -> bool:
	for vector in equipped_furniture.tile_matrix:
		var preview_tile_coords: Vector2i = hovered_tile_coords + vector
		var tile_data: TileData = tile_manager.layer.get_cell_tile_data(preview_tile_coords)
		if not tile_data: return true
	return false

func _clear_preview() -> void:
	if furniture_preview:
		furniture_preview.queue_free()
		furniture_preview = null

func _spawn_preview() -> void:
	var preview_ins: Furniture = equipped_furniture.get_furniture().instantiate()
	var pivot: Marker2D = preview_ins.get_node("Pivot")
	preview_ins.set_preview()
	preview_ins.global_position = tile_manager.get_gp_from_tile_coords(hovered_tile_coords) as Vector2 - pivot.global_position
	get_tree().root.add_child(preview_ins)
	furniture_preview = preview_ins

func _validate_preview() -> void:
	if _is_used_tile() or _is_incorrect_layer():
		furniture_preview.invalid_placement()

func _spawn_furnitrue() -> void:
	var shoppe_furniture: Node2D = get_tree().get_first_node_in_group("ShoppeFurniture")
	if not shoppe_furniture:
		push_warning("warning: cannot add furniture since no ShoppeFurniture scene was detected")
		return
	var furniture_ins = equipped_furniture.get_furniture().instantiate()
	var pivot: Marker2D = furniture_ins.get_node("Pivot")
	var tile_global_pos: Vector2 = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	furniture_ins.global_position = shoppe_furniture.to_local(tile_global_pos) as Vector2 - pivot.global_position
	furniture_ins.set_occupied_tiles(equipped_furniture.tile_matrix, hovered_tile_coords)
	shoppe_furniture.add_child(furniture_ins)
	placed_furniture.append(furniture_ins)

## -- signals --
func _on_new_tile_hovered(tile_coords: Vector2i) -> void:
	if not equipped_furniture: return
	hovered_tile_coords = tile_coords
	_clear_preview()
	_spawn_preview()
	_validate_preview()

func _on_action_pressed(_event: InputEvent) -> void:
	if not equipped_furniture: return
	if not furniture_preview: return
	if not furniture_preview.is_valid_placement: return
	_clear_preview()
	_spawn_furnitrue()

func _on_layer_mouse_out() -> void:
	_clear_preview()

func _on_rotate_pressed() -> void:
	if not equipped_furniture: return
	equipped_furniture.rotate_clockwise()
	_clear_preview()
	_spawn_preview()
	_validate_preview()
