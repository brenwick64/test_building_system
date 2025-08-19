class_name CraftingManager
extends Node

@export var inventory_manager: PlayerInventory
@export var ui: CanvasLayer
@export var ui_margin: int = 25

var current_crafting_ui: Control

## -- methods --
func toggle_ui(crafting_station: CraftingStation) -> void:
	if not current_crafting_ui:
		_create_new_ui(crafting_station)
		return
	var is_same_station: bool = current_crafting_ui and current_crafting_ui.crafting_station == crafting_station
	if is_same_station:
		current_crafting_ui.visible = not current_crafting_ui.visible
	else:
		current_crafting_ui.queue_free()
		_create_new_ui(crafting_station)

func handle_craft(recipe: RRecipe, crafting_station: CraftingStation) -> void:
	if not crafting_station:
		push_error("crafting_manager error: attempting to craft without current crafting station")
		return
	#TODO:
	#_check_input_items()
	_remove_input_items(recipe)
	crafting_station.craft(recipe)

## -- helper functions --
func _create_new_ui(crafting_station: CraftingStation) -> void:
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
