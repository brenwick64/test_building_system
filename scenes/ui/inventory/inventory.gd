extends Panel

signal item_selected(item: RItemData)

@export var item_slot_list: HBoxContainer
@export var inventory_manager: InventoryManager

## --overrides --
func _ready() -> void:
	for item_slot: Node in item_slot_list.get_children():
		item_slot.item_selected.connect(_on_item_selected)
	_focus_next_item_slot()

## -- helper functions --
func _focus_next_item_slot() -> void:
	for item_slot: Node in item_slot_list.get_children():
		if item_slot.inventory_item:
			item_slot.on_btn_pressed()
			return

func _get_next_empty_slot() -> PanelContainer:
	var item_slots: Array[Node] = item_slot_list.get_children() 
	for slot: PanelContainer in item_slots:
		if not slot.inventory_item:
			return slot
	return null

func _add_new_item_slot(inv_item: RInventoryItem) -> void:
	var next_empty: PanelContainer = _get_next_empty_slot()
	if not next_empty: return # TODO: handle full inventory
	next_empty.inventory_item = inv_item
	next_empty.refresh_ui()
 
func _update_existing_item_slot(inv_item: RInventoryItem) -> void:
	var item_slots: Array[Node] = item_slot_list.get_children()
	var matching_slot: Array[Node] = item_slots.filter(func(slot): return _matches_item_name(slot, inv_item.item.item_name))
	if matching_slot.size() > 0:
		matching_slot[0].inventory_item.count = inv_item.count
		matching_slot[0].refresh_ui()

func _matches_item_name(slot: PanelContainer, item_name: String) -> bool:
	if not slot.inventory_item: return false
	return slot.inventory_item.item.item_name == item_name

## -- internal signals  --
func _on_item_selected(item: RItemData) -> void:
	item_selected.emit(item)
	
## -- external signals  --
func _on_inventory_system_inventory_updated(inventory_items: Array[RInventoryItem]) -> void:
	var item_slots: Array[Node] = item_slot_list.get_children()
	for inv_item: RInventoryItem in inventory_items:
		var is_new_item: bool = item_slots.filter(func(slot): return _matches_item_name(slot, inv_item.item.item_name)).size() == 0
		if is_new_item: _add_new_item_slot(inv_item)
		else: _update_existing_item_slot(inv_item)

func _on_inventory_system_item_depleted(item: RItemData) -> void:
	var item_slots: Array[Node] = item_slot_list.get_children()
	for slot: PanelContainer in item_slots:
		if not slot.inventory_item: continue
		if slot.inventory_item.item.item_name == item.item_name:
			slot.clear_item()

func _on_input_manager_action_bar_pressed(number: int) -> void:
	for item_slot: Node in item_slot_list.get_children():
		if item_slot.index == number:
			item_slot.on_btn_pressed()
