class_name FurnitureManager
extends Node

signal furniture_placed(furniture_data: RFurniture)

@onready var outline_shader: Shader = preload("res://shaders/outline_shader.gdshader")

@export var tile_manager: TileManager

var equipped_furniture: RFurniture

var hovered_tile_coords: Vector2i
var furniture_preview: Furniture
var placed_furniture: Array[Furniture]

func _ready() -> void:
	tile_manager.new_tile_hovered.connect(_on_tile_manager_new_tile_hovered)
	tile_manager.layer_mouse_out.connect(_on_tile_manager_layer_mouse_out)
	
## -- methods --
func get_furniture_at_coords(tile_coords: Vector2i) -> Furniture:
	for furniture: Furniture in placed_furniture:
		if tile_coords in furniture.occupied_tiles:
			return furniture
	return null

func remove_furniture(furniture: Furniture) -> void:
	# remove any remaining items
	for item_slot: Node in furniture.item_slots.get_children():
		item_slot.remove()
	# remove furniture
	placed_furniture = placed_furniture.filter(func(f): return f != furniture)
	furniture.remove()

func remove_merchandise(merchandise: Merchandise) -> void:
	var item_slot: FurnitureItemSlot = merchandise.get_parent()
	item_slot.remove()

## -- helper functions --
func _is_used_tile() -> bool:
	for vector in equipped_furniture.get_tile_matrix():
		var preview_tile_coords: Vector2i = hovered_tile_coords + vector
		for furniture: Furniture in placed_furniture:
			if preview_tile_coords in furniture.occupied_tiles: 
				return true
	return false

func _is_incorrect_layer() -> bool:
	for vector in equipped_furniture.get_tile_matrix():
		var preview_tile_coords: Vector2i = hovered_tile_coords + vector
		var tile_data: TileData = tile_manager.layer.get_cell_tile_data(preview_tile_coords)
		if not tile_data: return true
	return false

func _clear_preview() -> void:
	if furniture_preview:
		furniture_preview.queue_free()
		furniture_preview = null

func _spawn_preview() -> void:
	if not hovered_tile_coords: return
	var preview_ins: Furniture = equipped_furniture.get_furniture()
	var pivot: Marker2D = preview_ins.get_node("Pivot")
	preview_ins.set_preview()
	preview_ins.global_position = tile_manager.get_gp_from_tile_coords(hovered_tile_coords) as Vector2 - pivot.global_position
	get_tree().root.add_child(preview_ins)
	furniture_preview = preview_ins

func _validate_preview() -> void:
	if not furniture_preview: return
	if _is_used_tile() or _is_incorrect_layer():
		furniture_preview.set_invalid_placement()

func _spawn_furnitrue() -> void:
	var shoppe_furniture: Node2D = get_tree().get_first_node_in_group("ShoppeFurniture")
	if not shoppe_furniture:
		push_warning("warning: cannot add furniture since no ShoppeFurniture scene was detected")
		return
	var furniture_ins: Node2D = equipped_furniture.get_furniture()
	# add global position
	var pivot: Marker2D = furniture_ins.get_node("Pivot")
	var tile_global_pos: Vector2 = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	furniture_ins.global_position = shoppe_furniture.to_local(tile_global_pos) as Vector2 - pivot.global_position
	# add shader
	var sprite: Sprite2D = furniture_ins.get_node("Sprite2D")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.set_shader(outline_shader)
	sprite.material = material
	# configure variables and add to scene
	furniture_ins.set_occupied_tiles(equipped_furniture.get_tile_matrix(), hovered_tile_coords)
	shoppe_furniture.add_child(furniture_ins)
	placed_furniture.append(furniture_ins)

## -- signals --
func _on_tile_manager_new_tile_hovered(tile_coords: Vector2i) -> void:
	hovered_tile_coords = tile_coords
	if not equipped_furniture: return
	_clear_preview()
	_spawn_preview()
	_validate_preview()

func _on_tile_manager_layer_mouse_out() -> void:
	_clear_preview()

## -- handlers --
func handle_action_pressed(_event: InputEvent) -> void:
	print("action_pressed")
	if not equipped_furniture: return
	if not furniture_preview: return
	if not furniture_preview.is_valid_placement: return
	_clear_preview()
	_spawn_furnitrue()
	furniture_placed.emit(equipped_furniture)

func handle_rotate_pressed() -> void:
	print("rotate pressed")
	if not equipped_furniture: return
	equipped_furniture.rotate_clockwise()
	_clear_preview()
	_spawn_preview()
	_validate_preview()

func handle_equipped_item_updated(current_item: RItemData) -> void:
	if current_item is RFurniture:
		equipped_furniture = current_item
		_clear_preview()
		_spawn_preview()
		_validate_preview()
	else:
		equipped_furniture = null
		_clear_preview()

func handle_item_depleted(item: RItemData) -> void:
	if item is RFurniture:
		equipped_furniture = null
		_clear_preview()
