class_name CraftingManager
extends Node

@export var inventory_manager: PlayerInventory
@export var ui: CanvasLayer
@export var ui_margin: int = 25

var current_crafting_ui: Control

## -- methods --
func toggle_ui(crafting_station: CraftingStation) -> void:
	# case 1 - no existing ui
	if not current_crafting_ui:
		_create_ui(crafting_station)
	# case 2 - crafting station ui is active
	elif current_crafting_ui.crafting_station == crafting_station:
		current_crafting_ui.visible = not current_crafting_ui.visible
	# case 3 - other ui is active
	elif current_crafting_ui.crafting_station != crafting_station:
		remove_ui(current_crafting_ui.crafting_station)
		_create_ui(crafting_station)

func remove_ui(crafting_station: CraftingStation) -> void:
	if not current_crafting_ui: return
	var is_active_ui: bool = current_crafting_ui.crafting_station == crafting_station
	if is_active_ui: 
		current_crafting_ui.queue_free()
		current_crafting_ui= null

func handle_craft(recipe: RRecipe, crafting_station: CraftingStation) -> void:
	if not crafting_station:
		push_error("crafting_manager error: attempting to craft without current crafting station")
		return
	var has_items: bool = inventory_manager.has_items(recipe.input_items)
	if not has_items:
		push_error("crafting_manager error: attempted to craft item without input items in inventory")
		return
	for inv_item: RInventoryItem in recipe.input_items:
		inventory_manager.remove_item(inv_item.item.item_id, inv_item.count)
	crafting_station.craft(recipe)

## -- helper functions --
func _create_ui(crafting_station: CraftingStation) -> void:
	var crafting_ui: Control = crafting_station.ui_scene.instantiate()
	crafting_ui.crafting_manager = self
	crafting_ui.crafting_station = crafting_station
	crafting_ui.set_anchors_preset(Control.PRESET_TOP_LEFT)
	crafting_ui.position = crafting_ui.position + Vector2(ui_margin, ui_margin)
	crafting_ui.inventory_items = inventory_manager.inventory_items
	inventory_manager.inventory_updated.connect(crafting_ui._on_inventory_updated)
	current_crafting_ui = crafting_ui
	ui.add_child(crafting_ui)

func _remove_input_items(recipe: RRecipe) -> void:
	for inv_item: RInventoryItem in recipe.input_items:
		inventory_manager.remove_item(inv_item.item.item_id, inv_item.count)
