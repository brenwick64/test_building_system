class_name Inventory
extends Node

signal inventory_updated(owner_id: String, inventory_items: Array[RInventoryItem])

var owner_id: String
var inventory_items: Array[RInventoryItem]

# TODO: Add loading of saved data

## -- methods --
func add_item(item_id: String, amount: int) -> void:
	var inventory_item: RInventoryItem = RInventoryItem.new()
	var item_data: RItemData = ItemsDB.get_item_data(item_id)
	if not item_data:
		push_error("error: no item data found for item_id: " + str(item_id))
		return
	inventory_item.item = item_data
	inventory_item.count = amount
	inventory_items.append(inventory_item)

func remove_item(item_id: String, amount: int) -> void:
	pass
	
