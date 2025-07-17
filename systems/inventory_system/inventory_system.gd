class_name InventoryManager
extends Node

signal equipped_item_updated(current_item: RItemData)
signal inventory_updated(inventory_items: Array[RInventoryItem])
signal item_depleted(item: RItemData)

@export var inv_items: Array[RInventoryItem]

var current_item: RItemData

## -- methods --
func add_item(new_item: RItemData) -> void:
	if not new_item: return
	var is_new_item: bool = inv_items.filter(func(i: RInventoryItem): return i.item.name == new_item.name).size() == 0
	if is_new_item: _add_new_inventory_item(new_item)
	else: _increment_existing_item(new_item)
	_prune_inv_items()
			
func remove_item(item: RItemData) -> void:
	for inv_item: RInventoryItem in inv_items:
		if inv_item.item.item_name == item.item_name:
			inv_item.count -= 1
	_prune_inv_items()

## -- overrides --
func _ready() -> void:
	inventory_updated.emit(inv_items)
	
## -- helper functions --
func _prune_inv_items() -> void:
	for inv_item: RInventoryItem in inv_items:
		if inv_item.count <= 0:
			item_depleted.emit(inv_item.item)
	inv_items = inv_items.filter(func(inv_item: RInventoryItem): return inv_item.count > 0)
	inventory_updated.emit(inv_items)

func _add_new_inventory_item(new_item: RItemData) -> void:
	var new_inv_item: RInventoryItem = RInventoryItem.new()
	new_inv_item.item = new_item
	new_inv_item.count = 1
	inv_items.append(new_inv_item)

func _increment_existing_item(new_item: RItemData) -> void:
	for inv_item: RInventoryItem in inv_items:
		if inv_item.item.name == new_item.name:
			inv_item.count += 1

func _on_inventory_item_selected(item: RItemData) -> void:
	current_item = item
	equipped_item_updated.emit(current_item)

func _on_placement_system_furniture_placed(furniture_data: RFurniture) -> void:
	remove_item(furniture_data)

func _on_placement_system_merchandise_placed(merchandise_data: RMerchandise) -> void:
	remove_item(merchandise_data)
