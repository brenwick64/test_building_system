class_name ItemDB
extends Node

#TODO: use a resource group to load item data
@onready var health_potion_data: RItemData = preload("res://resources/items/merchandise/health_potion.tres")
@onready var dagger_data: RItemData = preload("res://resources/items/merchandise/dagger.tres")
@onready var sword_data: RItemData = preload("res://resources/items/merchandise/sword.tres")
@onready var lrg_table_data: RItemData = preload("res://resources/items/furniture/large_table.tres")
@onready var sm_table_data: RItemData = preload("res://resources/items/furniture/small_table.tres")


@onready var items: Array[RItemData] = [
	health_potion_data,
	dagger_data,
	sword_data,
	lrg_table_data,
	sm_table_data
]

func get_item(item_id: String) -> RItemData:
	for item_data: RItemData in items:
		if item_data.item_id == item_id:
			return item_data
	return null
