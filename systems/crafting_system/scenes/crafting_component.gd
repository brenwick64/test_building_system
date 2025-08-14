class_name CraftingComponent
extends Node

@export var mouse_area: Area2D
@export var interactable_area: Area2D

#func _ready() -> void:
	#mouse_area.mouse_entered.connect(_on_mouse_area_mouse_entered)
	#mouse_area.mouse_exited.connect(_on_mouse_area_mouse_exited)
	#mouse_area.input_event.connect(_on_mouse_area_input_event)
	#interactable_area.area_entered.connect(_on_interactable_area_entered)
	#interactable_area.area_exited.connect(_on_interactable_area_exited)
	#
#func _on_mouse_area_mouse_entered():
	#is_hovered = true
	#if not player_within_range: return 
	#if not _are_hands_empty(): return
	#show_outline()
#
#func _on_mouse_area_mouse_exited():
	#is_hovered = false
	#if not _are_hands_empty(): return
	#hide_outline()
#
#func _on_mouse_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	#if not player_within_range: return
	#if not _are_hands_empty(): return
	#if event.is_action_released("Action"):
		#var crafting_manager: CraftingManager = get_tree().get_first_node_in_group("crafting_manager")
		#if not crafting_manager: return
		#crafting_manager.toggle_menu()
