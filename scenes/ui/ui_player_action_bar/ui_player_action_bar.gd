extends Panel

signal item_selected(item_id: String)

@export var inventory: Inventory
@export var item_slot_list: HBoxContainer

## --overrides --
func _ready() -> void:
	for item_slot: Node in item_slot_list.get_children():
		item_slot.item_selected.connect(_on_item_selected)
	_focus_next_item_slot()

## -- helper functions --
func _focus_next_item_slot() -> void:
	for item_slot: Node in item_slot_list.get_children():
		if item_slot.item_id and not item_slot.is_disabled:
			item_slot.handle_btn_pressed()
			return

func _get_next_empty_slot() -> PanelContainer:
	var item_slots: Array[Node] = item_slot_list.get_children() 
	for slot: PanelContainer in item_slots:
		if not slot.item_id:
			return slot
	return null

func _matches_item_id(slot: PanelContainer, item_id: String) -> bool:
	if not slot.item_id: return false
	return slot.item_id == item_id

### -- internal signals  --
func _on_item_selected(item_id: String) -> void:
	item_selected.emit(item_id)
	
### -- external signals  --
func _on_player_inventory_inventory_updated(_inventory_items: Array[RInventoryItem]) -> void:
	var item_slots: Array[Node] = item_slot_list.get_children()
	for slot: PanelContainer in item_slots:
		slot.refresh_ui()
	
func _on_player_inventory_item_depleted(item: RItemData) -> void:
	var item_slots: Array[Node] = item_slot_list.get_children()
	for slot: PanelContainer in item_slots:
		if not slot.item_id: continue
		if slot.item_id == item.item_id:
			slot.handle_item_depleted()

func _on_player_inventory_new_item_added(item_id: String) -> void:
	# check if empty slot exists for the item id
	for item_slot: Node in item_slot_list.get_children():
		if item_slot.item_id == item_id:
			return
	# check if empty item slot exists
	var empty_slot: PanelContainer = _get_next_empty_slot()
	if not empty_slot: return
	# add new item to action bar
	empty_slot.item_id = item_id
	empty_slot.add_icon()
	empty_slot.refresh_ui()

func _on_input_manager_action_bar_pressed(key: String) -> void:
	for item_slot: Node in item_slot_list.get_children():
		if item_slot.hotkey == key:
			item_slot.handle_btn_pressed()

func _on_player_inventory_item_selected(item: RItemData) -> void:
	# check if no item is selected
	if item: return
	for item_slot: Node in item_slot_list.get_children():
		item_slot.unfocus()
