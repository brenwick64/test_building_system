extends Node

signal item_placed(item: RItemData)

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
func _on_furniture_placed(item_data: RItemData) -> void:
	item_placed.emit(item_data)

func _on_merchandise_placed(item_data: RItemData) -> void:
	item_placed.emit(item_data)

## -- external signal handlers --
func _on_input_manager_action_pressed(event: InputEvent) -> void:
	_call_child_handlers("handle_action_pressed", [event])

func _on_input_manager_rotate_pressed() -> void:
	_call_child_handlers("handle_rotate_pressed")

func _on_player_inventory_item_selected(item: RItemData) -> void:
	_call_child_handlers("handle_equipped_item_updated", [item])

func _on_player_inventory_item_depleted(item: RItemData) -> void:
	_call_child_handlers("handle_item_depleted", [item])
