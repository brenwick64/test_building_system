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
#func _get_free_item_tiles(furniture_tiles: Array[Vector2i]) -> Array[Vector2i]:
	#var occupied_tiles: Array[Vector2i] = []
	#for merchandise: Merchandise in placed_merchandise:
		#for tile_coords: Vector2i in merchandise.occupied_tiles:
			#if tile_coords in furniture_tiles:
				#occupied_tiles.append(tile_coords)
	#return furniture_tiles.filter(func(tile): return not tile in occupied_tiles)

func _get_free_item_slot(tile_coords: Vector2i) -> Node2D:
	var furniture: Furniture = furniture_manager.get_furniture_at_coords(tile_coords)
	if not furniture: # no furniture to place item on 
		_clear_preview()
		return null
	var free_item_slot: Node2D = furniture.get_free_item_slot(equipped_merchandise, tile_coords)
	return free_item_slot

func _spawn_preview(item_slot: Node2D) -> void:
	var preview_ins: Merchandise = equipped_merchandise.item_scene.instantiate()
	preview_ins.set_preview()
	item_slot.add_child(preview_ins)
	merchandise_preview = preview_ins

func _clear_preview() -> void:
	if merchandise_preview:
		merchandise_preview.queue_free()
		merchandise_preview = null

func _validate_preview() -> void:
	pass

func _spawn_merchandise(item_slot: Node2D) -> void:
	var merchandise_ins: Merchandise = equipped_merchandise.item_scene.instantiate()
	item_slot.placed_item = merchandise_ins
	item_slot.add_child(merchandise_ins)
	placed_merchandise.append(merchandise_ins)

## -- signals --
func _on_tile_manager_new_tile_hovered(tile_coords: Vector2i) -> void:	
	hovered_tile_coords = tile_coords
	if not equipped_merchandise: return # merchandise manager not needed
	var free_item_slot: Node2D = _get_free_item_slot(hovered_tile_coords)
	if not free_item_slot: return
	_clear_preview()
	_spawn_preview(free_item_slot)
	_validate_preview()
 
func _on_tile_manager_layer_mouse_out() -> void:
	_clear_preview()

func _on_input_manager_action_pressed(event: InputEvent) -> void:
	if not equipped_merchandise: return
	if not merchandise_preview: return
	if not merchandise_preview.is_valid_placement: return
	var item_slot: Node2D = merchandise_preview.get_parent()
	_clear_preview()
	_spawn_merchandise(item_slot)
	inventory_manager.remove_item(equipped_merchandise)

func _on_inventory_manager_current_item_updated(current_item: RItem) -> void:
	if current_item is RMerchandise:
		equipped_merchandise = current_item
		var free_item_slot: Node2D = _get_free_item_slot(hovered_tile_coords)
		if not free_item_slot: return
		_clear_preview()
		_spawn_preview(free_item_slot)
		_validate_preview()
	else:
		equipped_merchandise = null
		_clear_preview()

func _on_inventory_manager_item_depleted(item: RItem) -> void:
	if item is RMerchandise:
		equipped_merchandise = null
		_clear_preview()
