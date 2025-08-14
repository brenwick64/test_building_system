class_name CraftingManager
extends Node

@export var player_inventory: PlayerInventory
@export var crafting_ui: Control

func toggle_ui() -> void:
	crafting_ui.visible = not crafting_ui.visible
