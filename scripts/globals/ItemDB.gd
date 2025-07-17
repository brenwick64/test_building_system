class_name ItemDB
extends Node

#TODO: use a resource group to load item data
# merchandise
@onready var health_potion: RItemData = preload("res://systems/placement_system/resources/merchandise/health_potion.tres")
@onready var dagger: RItemData = preload("res://systems/placement_system/resources/merchandise/dagger.tres")
@onready var sword: RItemData = preload("res://systems/placement_system/resources/merchandise/sword.tres")
@onready var spear: RItemData = preload("res://systems/placement_system/resources/merchandise/spear.tres")
@onready var shield: RItemData = preload("res://systems/placement_system/resources/merchandise/shield.tres")
# furniture
@onready var one_by_one_table: RItemData= preload("res://systems/placement_system/resources/furniture/1x1_table.tres")
@onready var two_by_one_table: RItemData = preload("res://systems/placement_system/resources/furniture/2x1_table.tres")
@onready var three_by_one_table: RItemData = preload("res://systems/placement_system/resources/furniture/3x1_table.tres")
@onready var two_by_two_table: RItemData = preload("res://systems/placement_system/resources/furniture/2x2_table.tres")

@onready var items: Array[RItemData] = [
	health_potion,
	dagger,
	sword,
	spear,
	shield,
	one_by_one_table,
	two_by_one_table,
	three_by_one_table,
	two_by_two_table
]

func get_item(item_id: String) -> RItemData:
	for item_data: RItemData in items:
		if item_data.item_id == item_id:
			return item_data
	return null
