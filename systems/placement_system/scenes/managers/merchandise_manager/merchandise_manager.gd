class_name MerchandiseManager
extends Node

signal merchandise_placed(item: RItemData)

@export var save_filename: String
@export var tile_manager: PlacementTileManager
@export var furniture_manager: FurnitureManager

@onready var outline_shader: Shader = preload("res://shaders/outline_shader.gdshader")

var equipped_merchandise: RItemData

var hovered_tile_coords: Vector2i
var merchandise_preview: PlaceableMerchandisePreview
var placed_merchandise: Array[PlaceableMerchandise]

func _ready() -> void:
	_load_merchandise()
	tile_manager.new_tile_hovered.connect(_on_tile_manager_new_tile_hovered)
	tile_manager.layer_mouse_out.connect(_on_tile_manager_layer_mouse_out)

## -- methods --
func remove_merchandise(merchandise: PlaceableMerchandise) -> void:
	var item_slot: FurnitureItemSlot = merchandise.get_parent()
	item_slot.remove()
	placed_merchandise = placed_merchandise.filter(
		func(merch: PlaceableMerchandise): return merch.tile_coords != merchandise.tile_coords
	)
	_save_merchandise()
	
## -- save/load --
func _save_merchandise():
	var array: Array[RSaveData] = []
	for merchandise_scene: PlaceableMerchandise in placed_merchandise:
		var packed_scene: PackedScene = PackedScene.new()
		packed_scene.pack(merchandise_scene)
		var save_data = RMerchandiseSaveData.get_resource_instance(
			packed_scene,
			merchandise_scene.merchandise_data,
			merchandise_scene.rotation,
			merchandise_scene.tile_coords
		)
		array.append(save_data)
	SaveManager.save_resource_data(save_filename, array)

func _load_merchandise():
	var save_data_arr: Array[RSaveData] = SaveManager.load_resource_data(save_filename)
	if not save_data_arr: return
	for save_data: RMerchandiseSaveData in save_data_arr:
		_spawn_saved_merchandise(
			save_data.item_data,
			save_data.tile_coords,
			save_data.rotation
		)

func _spawn_saved_merchandise(item_data: RItemData, coords: Vector2i, rotation: float)-> void:
	var parent_furniture: PlaceableFurniture = furniture_manager.get_furniture_at_coords(coords)
	if not parent_furniture: 
		push_error("merchandise_manager error: no parent furniture found at coords: " + str(coords))
		return
	var item_slot: FurnitureItemSlot = parent_furniture.get_free_item_slot(item_data, coords)
	if not item_slot:
		push_error("merchandise_manager error: no item slot found at coords: " + str(coords))
		return
	var merch_ins: PlaceableMerchandise = item_data.placeable.new_placeable_scene()
	# add outline shader
	var sprite: Sprite2D = merch_ins.get_node("Sprite2D")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = outline_shader
	sprite.material = material
	# add other variables
	merch_ins.merchandise_data = item_data
	merch_ins.tile_coords = coords
	merch_ins.rotation = rotation
	item_slot.placed_item = merch_ins
	item_slot.add_child(merch_ins)
	placed_merchandise.append(merch_ins)

## -- helper functions --
func _get_free_item_slot(tile_coords: Vector2i) -> Node2D:
	var furniture: PlaceableFurniture = furniture_manager.get_furniture_at_coords(tile_coords)
	if not furniture: # no furniture to place item on 
		_clear_preview()
		return null
	var free_item_slot: Node2D = furniture.get_free_item_slot(equipped_merchandise, tile_coords)
	return free_item_slot

func _spawn_preview(item_slot: Node2D) -> void:
	var preview_ins: PlaceableMerchandisePreview = equipped_merchandise.placeable.new_placeable_preview()
	preview_ins.rotation = deg_to_rad(equipped_merchandise.placeable.get_rotation_deg())
	item_slot.add_child(preview_ins)
	merchandise_preview = preview_ins

func _clear_preview() -> void:
	if merchandise_preview:
		merchandise_preview.queue_free()
		merchandise_preview = null

func _is_within_range() -> bool:
	var player: Player = get_tree().get_first_node_in_group("player")
	if not player: return false
	var preview_pos: Vector2 = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	if player.global_position.distance_to(preview_pos) < PlayerStats.build_distance:
		return true
	return false
	
func _validate_preview() -> void:
	pass

func _spawn_merchandise(item_slot: Node2D) -> void:
	var merchandise_ins: PlaceableMerchandise = equipped_merchandise.placeable.new_placeable_scene()
	merchandise_ins.merchandise_data = equipped_merchandise
	merchandise_ins.rotation = deg_to_rad(equipped_merchandise.placeable.get_rotation_deg())
	merchandise_ins.tile_coords = hovered_tile_coords
	# add outline shader
	var sprite: Sprite2D = merchandise_ins.get_node("Sprite2D")
	var material: ShaderMaterial = ShaderMaterial.new()
	material.shader = outline_shader
	sprite.material = material
	# configure variables and add to scene
	item_slot.placed_item = merchandise_ins
	item_slot.add_child(merchandise_ins)
	placed_merchandise.append(merchandise_ins)

### -- signals --
func _on_tile_manager_new_tile_hovered(tile_coords: Vector2i) -> void:
	hovered_tile_coords = tile_coords
	if not equipped_merchandise: return # merchandise manager not needed
	var free_item_slot: Node2D = _get_free_item_slot(hovered_tile_coords)
	if not free_item_slot: return
	_clear_preview()
	if _is_within_range():
		_spawn_preview(free_item_slot)
		_validate_preview()
 
func _on_tile_manager_layer_mouse_out() -> void:
	hovered_tile_coords = Vector2i.ZERO
	_clear_preview()

## -- handlers --
func handle_action_pressed(_event: InputEvent) -> void:
	if not equipped_merchandise: return
	if not merchandise_preview: return
	if not merchandise_preview.is_valid_placement: return
	var item_slot: Node2D = merchandise_preview.get_parent()
	_clear_preview()
	_spawn_merchandise(item_slot)
	_save_merchandise()
	merchandise_placed.emit(equipped_merchandise)

func handle_rotate_pressed() -> void:
	if not merchandise_preview: return
	if not equipped_merchandise.placeable.is_rotatable: return
	var item_slot: Node2D = merchandise_preview.get_parent()
	equipped_merchandise.placeable.flip()
	_clear_preview()
	_spawn_preview(item_slot)
	_validate_preview()
 
func handle_equipped_item_updated(current_item: RItemData) -> void:
	# case - no item is equipped
	if not current_item: 
		_clear_preview()
		equipped_merchandise = null
		return
	if current_item.placeable is RPlaceableMerchandise:
		equipped_merchandise = current_item
		var free_item_slot: Node2D = _get_free_item_slot(hovered_tile_coords)
		if not free_item_slot: return
		_clear_preview()
		_spawn_preview(free_item_slot)
		_validate_preview()
	else:
		equipped_merchandise = null
		_clear_preview()

func handle_item_depleted(item: RItemData) -> void:
	if item.placeable and item.placeable is RPlaceableMerchandise:
		equipped_merchandise = null
		_clear_preview()
