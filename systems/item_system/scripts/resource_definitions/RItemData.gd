class_name RItemData
extends Resource

@export var item_id: String
@export var item_name: String

@export var placeable: RPlaceableItem
@export var icon: RItemIcon
@export var pickup: RPickup

func init() -> void: # persists item_id to other resources dynamically
	var child_resources: Array[Resource] = [placeable, icon, pickup]
	for resource: Resource in child_resources:
		if resource:
			resource.item_id = item_id
