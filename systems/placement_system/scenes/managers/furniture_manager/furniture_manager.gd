class_name FurnitureManager
extends Node

signal placed_furniture_updated(placed_furniture: Array[PlaceableFurniture])
signal furniture_placed(furniture_data: RItemData)

@export var save_filename: String
@export var tile_manager: PlacementTileManager

var equipped_furniture_data: RItemData
var hovered_tile_coords: Vector2i
var furniture_preview: PlaceableFurniturePreview
var placed_furniture: Array[PlaceableFurniture]

func _ready() -> void:
	_load_furniture()
	tile_manager.new_tile_hovered.connect(_on_tile_manager_new_tile_hovered)
	tile_manager.layer_mouse_out.connect(_on_tile_manager_layer_mouse_out)
	
## -- methods --
func get_furniture_at_coords(tile_coords: Vector2i) -> PlaceableFurniture:
	for furniture: PlaceableFurniture in placed_furniture:
		if tile_coords in furniture.occupied_tiles:
			return furniture
	return null

func remove_furniture(furniture: PlaceableFurniture) -> void:
	# remove any remaining items
	if furniture.item_slots:
		for item_slot: Node in furniture.item_slots.get_children():
			item_slot.remove()
	# remove furniture
	placed_furniture = placed_furniture.filter(func(f): return f != furniture)
	placed_furniture_updated.emit(placed_furniture)
	furniture.remove()
	_save_furniture()

func _spawn_saved_furniture(
	furniture_data: RItemData, 
	global_pos: Vector2, 
	primary_tile: Vector2i,
	occupied_tiles: Array[Vector2i]
	) -> void:
	var shoppe_furniture: Node2D = get_tree().get_first_node_in_group("ShoppeFurniture")
	if not shoppe_furniture:
		push_warning("warning: cannot add furniture since no ShoppeFurniture scene was detected")
		return
	var furniture_ins: Node2D = furniture_data.placeable.get_furniture()
	furniture_ins.furniture_data = furniture_data
	furniture_ins.global_position = global_pos
	furniture_ins.primary_tile = primary_tile
	furniture_ins.set_occupied_tiles(furniture_data.placeable.get_tile_matrix(), primary_tile)
	shoppe_furniture.add_child(furniture_ins)
	placed_furniture.append(furniture_ins)
	placed_furniture_updated.emit(placed_furniture)

## -- save/load --
func _save_furniture():
	var array: Array[RSaveData] = []
	for furniture_scene: PlaceableFurniture in placed_furniture:
		var packed_scene: PackedScene = PackedScene.new()
		packed_scene.pack(furniture_scene)
		var save_data: RFurnitureSaveData = RFurnitureSaveData.new_resource_instance(
			packed_scene,
			furniture_scene.furniture_data,
			furniture_scene.global_position,
			furniture_scene.primary_tile,
			furniture_scene.occupied_tiles
		)
		array.append(save_data)
		SaveManager.save_resource_data(save_filename, array)

func _load_furniture():
	var save_data_arr: Array[RSaveData] = SaveManager.load_resource_data(save_filename)
	if not save_data_arr: return
	for save_data: RFurnitureSaveData in save_data_arr:
		_spawn_saved_furniture(
			save_data.item_data,
			save_data.global_pos,
			save_data.primary_tile,
			save_data.occupied_tiles
		)

## -- helper functions --
func _is_used_tile() -> bool:
	for vector in equipped_furniture_data.placeable.get_tile_matrix():
		var preview_tile_coords: Vector2i = hovered_tile_coords + vector
		for furniture: PlaceableFurniture in placed_furniture:
			if preview_tile_coords in furniture.occupied_tiles: 
				return true
	return false

func _is_incorrect_layer() -> bool:
	for vector in equipped_furniture_data.placeable.get_tile_matrix():
		var preview_tile_coords: Vector2i = hovered_tile_coords + vector
		var tile_data: TileData = tile_manager.layer.get_cell_tile_data(preview_tile_coords)
		if not tile_data: return true
	return false

func _is_within_range() -> bool:
	var player: Player = get_tree().get_first_node_in_group("player")
	if not player: return false
	var preview_pos: Vector2 = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	if player.global_position.distance_to(preview_pos) < PlayerStats.build_distance:
		return true
	return false

func _clear_preview() -> void:
	if furniture_preview:
		furniture_preview.queue_free()
		furniture_preview = null

func _spawn_preview() -> void:
	if not hovered_tile_coords: return
	var placeable: RPlaceableFurniture = equipped_furniture_data.placeable
	var preview_ins: PlaceableFurniturePreview = placeable.get_furniture_preview()
	var pivot: Marker2D = preview_ins.base_scene.pivot
	preview_ins.global_position = tile_manager.get_gp_from_tile_coords(hovered_tile_coords) as Vector2 - pivot.global_position
	preview_ins.is_obstructed_updated.connect(_on_furniture_preview_obstructed_updated)
	get_tree().root.add_child(preview_ins)
	furniture_preview = preview_ins

func _validate_preview() -> void:
	if not furniture_preview: return
	if _is_used_tile() or _is_incorrect_layer() or furniture_preview.is_obstructed:
		furniture_preview.set_invalid_placement()
	else:
		furniture_preview.set_valid_placement()

func _spawn_furniture() -> void:
	var shoppe_furniture: Node2D = get_tree().get_first_node_in_group("ShoppeFurniture")
	if not shoppe_furniture:
		push_warning("warning: cannot add furniture since no ShoppeFurniture scene was detected")
		return
	var furniture_ins: Node2D = equipped_furniture_data.placeable.get_furniture()
	# add global position
	var pivot: Marker2D = furniture_ins.base_scene.pivot
	var tile_global_pos: Vector2 = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	furniture_ins.furniture_data = equipped_furniture_data
	furniture_ins.global_position = shoppe_furniture.to_local(tile_global_pos) as Vector2 - pivot.global_position
	furniture_ins.primary_tile = hovered_tile_coords
	# configure variables and add to scene
	furniture_ins.set_occupied_tiles(equipped_furniture_data.placeable.get_tile_matrix(), furniture_ins.primary_tile)
	shoppe_furniture.add_child(furniture_ins)
	placed_furniture.append(furniture_ins)
	placed_furniture_updated.emit(placed_furniture)
	_save_furniture()

## -- signals --
func _on_tile_manager_new_tile_hovered(tile_coords: Vector2i) -> void:
	hovered_tile_coords = tile_coords
	if not equipped_furniture_data: return
	_clear_preview()
	if _is_within_range():
		_spawn_preview()
		_validate_preview()

func _on_tile_manager_layer_mouse_out() -> void:
	hovered_tile_coords = Vector2i.ZERO
	_clear_preview()

func _on_furniture_preview_obstructed_updated() -> void:
	_validate_preview()

## -- handlers --
func handle_action_pressed(_event: InputEvent) -> void:
	if not equipped_furniture_data: return
	if not furniture_preview: return
	if not furniture_preview.is_valid_placement: return
	_clear_preview()
	_spawn_furniture()
	furniture_placed.emit(equipped_furniture_data)

func handle_rotate_pressed() -> void:
	if not equipped_furniture_data: return
	var placeable: RPlaceableItem = equipped_furniture_data.placeable
	if not placeable: return
	placeable.rotate_clockwise()
	_clear_preview()
	_spawn_preview()
	_validate_preview()

func handle_equipped_item_updated(current_item: RItemData) -> void:
	# case - no item is equipped
	if not current_item:
		equipped_furniture_data = null
		_clear_preview() 
		return
	if current_item.placeable and current_item.placeable is RPlaceableFurniture:
		equipped_furniture_data = current_item
		_clear_preview()
		_spawn_preview()
		_validate_preview()
	else:
		equipped_furniture_data = null
		_clear_preview()

func handle_item_depleted(item: RItemData) -> void:
	if item.placeable and item.placeable is RPlaceableFurniture:
		equipped_furniture_data = null
		_clear_preview()
