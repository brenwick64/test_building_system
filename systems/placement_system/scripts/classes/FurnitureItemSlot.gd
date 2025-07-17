class_name FurnitureItemSlot
extends Node2D

@export var item_matrix: Array[Vector2i]
@export var slot_dimensions: Vector2i

var placed_item: Item

func remove() -> void:
	if not placed_item: return
	placed_item.remove()
	placed_item = null
