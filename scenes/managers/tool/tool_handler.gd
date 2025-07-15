class_name ToolHandler
extends Node

var hovered_tile: Vector2i
var hovered_node: Item

## -- helper functions --
func _clear_hovered_node() -> void:
	if not hovered_node: return
	hovered_node.unfocus()
	hovered_node = null

func _highlight_hovered_node() -> void:
	hovered_node.focus()

## -- handler methods --
func handle_new_tile_hovered(tile_coords: Vector2i, furniture_manager: FurnitureManager) -> void:
	hovered_tile = tile_coords
	_clear_hovered_node()
	var furniture: Furniture = furniture_manager.get_furniture_at_coords(tile_coords)
	if not furniture: return
	var occupied_item_slot: FurnitureItemSlot = furniture.get_occupied_slot_at_coords(tile_coords)
	if occupied_item_slot:
		hovered_node = occupied_item_slot.placed_item
	else:
		hovered_node = furniture
	_highlight_hovered_node()

func handle_layer_mouse_out() -> void:
	_clear_hovered_node()

func handle_action_pressed(furniture_manager: FurnitureManager) -> void:
	if not hovered_node: return
	if hovered_node is Furniture:
		furniture_manager.remove_furniture(hovered_node as Furniture)
		hovered_node = null
	elif hovered_node is Merchandise:
		furniture_manager.remove_merchandise(hovered_node as Merchandise)
		hovered_node = null
	# TODO: hacky way of checking for another item
	handle_new_tile_hovered(hovered_tile, furniture_manager)

func handle_current_item_updated() -> void:
	_clear_hovered_node()
