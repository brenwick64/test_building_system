extends Node

signal furniture_placed(furniture_data: RFurniture)
signal merchandise_placed(merchandise_data: RMerchandise)

# required variables
@export var placeable_layer: TileMapLayer
# child managers
@onready var placement_tile_manager: TileManager = $PlacementTileManager
@onready var furniture_manager: FurnitureManager = $FurnitureManager
@onready var merchandise_manager: MerchandiseManager = $MerchandiseManager

func _ready() -> void:
	furniture_manager.furniture_placed.connect(_on_furniture_placed)
	merchandise_manager.merchandise_placed.connect(_on_merchandise_placed)
	
## -- helper functions --
func _call_child_handlers(handler_name: String, args: Array = []):
	for child: Node in get_children():
		if child.has_method(handler_name):
			child.callv(handler_name, args)
			
## -- internal signal handlers --
func _on_furniture_placed(furniture_data: RFurniture) -> void:
	furniture_placed.emit(furniture_data)

func _on_merchandise_placed(merchandise_data: RMerchandise) -> void:
	merchandise_placed.emit(merchandise_data)

## -- external signal handlers --
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	_call_child_handlers("handle_action_pressed", [event])

func _on_input_manager_rotate_pressed() -> void:
	_call_child_handlers("handle_rotate_pressed")

func _on_inventory_system_equipped_item_updated(current_item: RItemData) -> void:
	_call_child_handlers("handle_equipped_item_updated", [current_item])

func _on_inventory_system_item_depleted(item: RItemData) -> void:
	_call_child_handlers("handle_item_depleted", [item])
