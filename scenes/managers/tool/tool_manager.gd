class_name ToolManager
extends Node

@export var remover_tool_handler: ToolHandler
@export var furniture_manager: FurnitureManager

var equipped_tool: RTool

## -- helper functions --
func _get_tool_handler(tool: RTool) -> ToolHandler:
	match tool.item_name:
		"remover_tool": return remover_tool_handler
	return null

## -- signals --
func _on_tile_manager_new_tile_hovered(tile_coords: Vector2i) -> void:
	if not equipped_tool: return
	var tool_handler: ToolHandler = _get_tool_handler(equipped_tool)
	if not tool_handler: return
	tool_handler.handle_new_tile_hovered(tile_coords, furniture_manager)

func _on_tile_manager_layer_mouse_out() -> void:
	if not equipped_tool: return
	var tool_handler: ToolHandler = _get_tool_handler(equipped_tool)
	if not tool_handler: return
	tool_handler.handle_layer_mouse_out()
	
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	if not equipped_tool: return
	var tool_handler: ToolHandler = _get_tool_handler(equipped_tool)
	if not tool_handler: return
	tool_handler.handle_action_pressed(furniture_manager)

func _on_inventory_manager_current_item_updated(current_item: RItemData) -> void:
	# reset any stale tool state
	if equipped_tool and (equipped_tool != current_item):
		var tool_handler: ToolHandler = _get_tool_handler(equipped_tool)
		if tool_handler: tool_handler.handle_current_item_updated()
		
	if current_item is RTool:
		equipped_tool = current_item	
	else:
		equipped_tool = null
