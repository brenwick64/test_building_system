class_name Inventory
extends Node

signal inventory_updated(inventory_items: Array[RInventoryItem])
signal new_item_added(item_id: String) 
signal item_depleted(item: RItemData)

# TODO: Add loading of saved data
var inventory_items: Array[RInventoryItem]

func _ready() -> void:
	inventory_updated.emit(inventory_items)

## -- methods --
func get_item(item_id: String) -> RInventoryItem:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.item.item_id == item_id:
			return inv_item
	return null

func add_item(item_id: String, amount: int) -> void:
	var is_new_item: bool = inventory_items.filter(func(i: RInventoryItem): return i.item.item_id == item_id).size() == 0
	if is_new_item:
		_add_new_inventory_item(item_id, amount)
		new_item_added.emit(item_id)
	else: 
		_increment_existing_item(item_id, amount)
	inventory_updated.emit(inventory_items)

func remove_item(item_id: String, amount: int) -> void:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.item.item_id == item_id:
			inv_item.count = max(0, inv_item.count - amount)
	_prune_depleted_items()

func has_items(inv_items: Array[RInventoryItem]) -> bool:
	for inv_item: RInventoryItem in inv_items:
		# case 1 - item doesnt exist in inventory
		var item_exists: bool = inventory_items.filter(
			func(i: RInventoryItem): return i.item.item_id == inv_item.item.item_id
		).size() > 0
		if not item_exists: return false
			
		# case 2 - item exists but is not enough
		for player_inv_item: RInventoryItem in inventory_items:
			if inv_item.item.item_id == player_inv_item.item.item_id:
				if inv_item.count > player_inv_item.count:
					return false
	return true

## -- helper functions --
func _signal_item_depleted(inv_item: RInventoryItem) -> void:
	item_depleted.emit(inv_item.item)

func _prune_depleted_items() -> void:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.count <= 0:
			_signal_item_depleted(inv_item)
	inventory_items = inventory_items.filter(func(inv_item: RInventoryItem): return inv_item.count > 0)
	inventory_updated.emit(inventory_items)

func _add_new_inventory_item(item_id: String, amount: int) -> void:
	var new_inv_item: RInventoryItem = RInventoryItem.new()
	var item_data: RItemData = ItemsDB.get_item_data(item_id)
	if not item_data:
		push_error("error: no item data found for item_id: " + str(item_id))
		return
	new_inv_item.item = item_data
	new_inv_item.count = amount
	inventory_items.append(new_inv_item)

func _increment_existing_item(item_id: String, amount: int) -> void:
	for inv_item: RInventoryItem in inventory_items:
		if inv_item.item.item_id == item_id:
			inv_item.count += amount
