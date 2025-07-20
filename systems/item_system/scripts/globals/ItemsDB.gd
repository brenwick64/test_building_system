class_name ItemsDB
extends Node

@onready var items_rg: ResourceGroup = preload("res://resource_groups/items.tres")

static var items_arr: Array[RItemData]

func _ready() -> void:
	items_rg.load_all_into(items_arr)
	for item: RItemData in items_arr:
		item.init() # persists item_id to all child resources

static func get_item_data(item_id: String) -> RItemData:
	var filtered_arr = items_arr.filter(func(item: RItemData): return item.item_id == item_id)
	if filtered_arr:
		return filtered_arr[0]
	return null
