class_name MerchandiseManager
extends Node

@export var furniture_manager: FurnitureManager
@export var inventory_manager: InventoryManager
@export var input_manager: InputManager
@export var tile_manager: TileManager

var equipped_merchandise: RMerchandise

var hovered_tile_coords: Vector2i
var merchandise_preview: Merchandise
var placed_merchandise: Array[Merchandise]

## -- helper functions --
func _get_free_item_tiles(furniture_tiles: Array[Vector2i]) -> Array[Vector2i]:
	var occupied_tiles: Array[Vector2i] = []
	for merchandise: Merchandise in placed_merchandise:
		for tile_coords: Vector2i in merchandise.occupied_tiles:
			if tile_coords in furniture_tiles:
				occupied_tiles.append(tile_coords)
	return furniture_tiles.filter(func(tile): return not tile in occupied_tiles)

func _get_valid_item_tiles(pivot_tile: Vector2i, free_tiles: Array[Vector2i]) -> Array[Vector2i]:
	# TODO: add logic to check multiple tiles for larger items
	if pivot_tile not in free_tiles: return []
	return [pivot_tile]

func _spawn_preview(furniture: Furniture, tile_coords: Vector2i) -> void:
	var preview_ins: Merchandise = equipped_merchandise.item_scene.instantiate()
	preview_ins.set_preview()
	preview_ins.global_position = tile_manager.get_gp_from_tile_coords(tile_coords)
	get_tree().root.add_child(preview_ins)
	merchandise_preview = preview_ins

func _clear_preview() -> void:
	if merchandise_preview:
		merchandise_preview.queue_free()
		merchandise_preview = null

func _validate_preview() -> void:
	pass

func _spawn_merchandise() -> void:
	var shoppe_merchandise: Node2D = get_tree().get_first_node_in_group("ShoppeMerchandise")
	if not shoppe_merchandise:
		push_warning("warning: cannot add furniture since no ShoppeFurniture scene was detected")
		return
	var merchandise_ins: Merchandise = equipped_merchandise.item_scene.instantiate()
	merchandise_ins.global_position = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	merchandise_ins.occupied_tiles = [hovered_tile_coords]
	shoppe_merchandise.add_child(merchandise_ins)
	placed_merchandise.append(merchandise_ins)

## -- signals --
func _on_tile_manager_new_tile_hovered(tile_coords: Vector2i) -> void:
	if not equipped_merchandise: return
	hovered_tile_coords = tile_coords
	var furniture: Furniture = furniture_manager.get_furniture_at_coords(tile_coords)
	if not furniture: return
	var free_coords: Array[Vector2i] = _get_free_item_tiles(furniture.occupied_tiles)
	if not free_coords: return
	var valid_tiles: Array[Vector2i] = _get_valid_item_tiles(tile_coords, free_coords)
	if not valid_tiles: return
	_clear_preview()
	_spawn_preview(furniture, valid_tiles[0])
	_validate_preview()

func _on_tile_manager_layer_mouse_out() -> void:
	_clear_preview()

func _on_input_manager_action_pressed(event: InputEvent) -> void:
	if not equipped_merchandise: return
	if not merchandise_preview: return
	if not merchandise_preview.is_valid_placement: return
	_clear_preview()
	_spawn_merchandise()
	inventory_manager.remove_item(equipped_merchandise)

func _on_inventory_manager_current_item_updated(current_item: RItem) -> void:
	if current_item is RMerchandise:
		equipped_merchandise = current_item
	else:
		equipped_merchandise = null
		_clear_preview()

func _on_inventory_manager_item_depleted(item: RItem) -> void:
	if item is RMerchandise:
		equipped_merchandise = null
		_clear_preview()
