class_name CraftingManager
extends Node

@export var inventory_manager: PlayerInventory
@export var crafting_ui: Control

## -- methods --
func toggle_ui(crafting_station: CraftingStation) -> void:
	if not crafting_station: return
	crafting_ui.visible = not crafting_ui.visible
	crafting_ui.current_crafting_station = crafting_station

func handle_craft(recipe: RRecipe, crafting_station: CraftingStation) -> void:
	if not crafting_station:
		push_error("crafting_manager error: attempting to craft without current crafting station")
		return
	crafting_ui.visible = false
	#TODO:
	#_check_input_items()
	_remove_input_items(recipe)
	crafting_station.craft(recipe)

## -- helper functions --
func _remove_input_items(recipe: RRecipe) -> void:
	for inv_item: RInventoryItem in recipe.input_items:
		inventory_manager.remove_item(inv_item.item.item_id, inv_item.count)
