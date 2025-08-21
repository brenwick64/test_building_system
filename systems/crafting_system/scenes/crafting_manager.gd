class_name CraftingManager
extends Node

@export var inventory_manager: PlayerInventory
@export var ui: CanvasLayer
@export var ui_margin: int = 25

var current_crafting_ui: Control

## -- methods --
func toggle_ui(crafting_station: CraftingStation) -> void:
	if current_crafting_ui:
		remove_ui(crafting_station)
	else:
		current_crafting_ui = _create_ui(crafting_station)

func remove_ui(crafting_station: CraftingStation) -> void:
	if current_crafting_ui.crafting_station == crafting_station:
		current_crafting_ui.queue_free()
		current_crafting_ui = null

func handle_craft(recipe: RRecipe, crafting_station: CraftingStation) -> void:
	if not crafting_station:
		push_error("crafting_manager error: attempting to craft without current crafting station")
		return
	if not inventory_manager.has_items(recipe.input_items):
		push_error("crafting_manager error: attempted to craft item without input items in inventory")
		return
	if crafting_station.is_crafting:	
		return
	# if all checks are satisfied, allow craft
	_remove_items_from_inventory(recipe.input_items)
	crafting_station.craft(recipe)
	toggle_ui(crafting_station)

## -- helper functions --
func _remove_items_from_inventory(inv_items: Array[RInventoryItem]) -> void:
	for inv_item: RInventoryItem in inv_items:
		inventory_manager.remove_item(inv_item.item.item_id, inv_item.count)

func _create_ui(crafting_station: CraftingStation) -> UICraftingMenu:
	var crafting_ui: UICraftingMenu = crafting_station.ui_scene.instantiate()
	crafting_ui.crafting_manager = self
	crafting_ui.crafting_station = crafting_station
	crafting_ui.set_anchors_preset(Control.PRESET_TOP_LEFT)
	crafting_ui.position = crafting_ui.position + Vector2(ui_margin, ui_margin)
	crafting_ui.inventory_items = inventory_manager.inventory_items
	inventory_manager.inventory_updated.connect(crafting_ui._on_inventory_updated)
	ui.add_child(crafting_ui)
	return crafting_ui

func _remove_input_items(recipe: RRecipe) -> void:
	for inv_item: RInventoryItem in recipe.input_items:
		inventory_manager.remove_item(inv_item.item.item_id, inv_item.count)
