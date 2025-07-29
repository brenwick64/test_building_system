class_name PlayerInventory
extends Inventory

signal item_selected(item: RItemData)
var selected_item: RItemData

## -- signals --
func _on_placement_system_item_placed(item: RItemData) -> void:
	remove_item(item.item_id, 1)

func _on_ui_player_inventory_item_selected(item_id: String) -> void:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.item.item_id == item_id:
			item_selected.emit(inv_item.item)
