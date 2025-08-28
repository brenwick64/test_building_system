class_name RInventoryItemSaveData
extends RSaveData

@export var item_data: RItemData
@export var count: int
@export var stackable: bool

static func pack_save_data(element) -> RInventoryItemSaveData:
	var inv_item: RInventoryItem = element as RInventoryItem
	if inv_item == null:
		push_error("Invalid type passed to RInventoryItemSaveData: " + str(element))
		return null
	var save_data: RInventoryItemSaveData = RInventoryItemSaveData.new()
	save_data.item_data = inv_item.item
	save_data.count = inv_item.count
	save_data.stackable = inv_item.stackable
	return save_data

static func unpack_save_data(save_data: RInventoryItemSaveData) -> RInventoryItem:
	var inv_item: RInventoryItem = RInventoryItem.new()
	inv_item.item = save_data.item_data
	inv_item.count = save_data.count
	inv_item.stackable = save_data.stackable
	return inv_item
