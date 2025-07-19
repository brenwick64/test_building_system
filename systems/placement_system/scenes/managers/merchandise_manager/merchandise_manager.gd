class_name MerchandiseManager
extends Node

signal merchandise_placed(item: RItemData)

@onready var outline_shader: Shader = preload("res://shaders/outline_shader.gdshader")

@export var tile_manager: TileManager
@export var furniture_manager: FurnitureManager

var equipped_merchandise: RItemData

var hovered_tile_coords: Vector2i
var merchandise_preview: PlaceableMerchandise
var placed_merchandise: Array[PlaceableMerchandise]

func _ready() -> void:
	tile_manager.new_tile_hovered.connect(_on_tile_manager_new_tile_hovered)
	tile_manager.layer_mouse_out.connect(_on_tile_manager_layer_mouse_out)
	
## -- helper functions --
func _get_free_item_slot(tile_coords: Vector2i) -> Node2D:
	var furniture: PlaceableFurniture = furniture_manager.get_furniture_at_coords(tile_coords)
	if not furniture: # no furniture to place item on 
		_clear_preview()
		return null
	var free_item_slot: Node2D = furniture.get_free_item_slot(equipped_merchandise, tile_coords)
	return free_item_slot

func _spawn_preview(item_slot: Node2D) -> void:
	var preview_ins: PlaceableItem = equipped_merchandise.new_item_scene()
	preview_ins.rotation = deg_to_rad(equipped_merchandise.placeable.get_rotation_deg())
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
	var merchandise_ins: PlaceableMerchandise = equipped_merchandise.new_item_scene()
	merchandise_ins.rotation = deg_to_rad(equipped_merchandise.placeable.get_rotation_deg())
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
