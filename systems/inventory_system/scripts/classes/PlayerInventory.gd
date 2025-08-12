class_name PlayerInventory
extends Inventory

signal item_selected(item: RItemData)

var selected_item: RItemData

## -- overrides --
func _signal_item_depleted(inv_item: RInventoryItem) -> void:
	super._signal_item_depleted(inv_item)
	# remove equipped item if player runs out
	if inv_item.item.item_id == selected_item.item_id:
		selected_item = null

## -- signals --
	
func _on_placement_manager_item_placed(item: RItemData) -> void:
	remove_item(item.item_id, 1)

func _on_ui_player_inventory_item_selected(item_id: String) -> void:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.item.item_id == item_id:
			# case 1 - selected item is already selected
			if selected_item and (item_id == selected_item.item_id):
				selected_item = null
				item_selected.emit(null)
			# case 2 - selected item is new
			else:
				selected_item = inv_item.item
				item_selected.emit(inv_item.item)
