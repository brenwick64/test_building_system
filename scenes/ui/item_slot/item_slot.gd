extends PanelContainer

signal item_selected(item: RItemData)

@export var item_btn: Button
@export var index_label: Label
@export var circle_panel: Panel
@export var item_count: Label

@export var hotkey: String
@export var inventory_item: RInventoryItem

var is_disabled: bool = false

## -- methods --
func on_btn_pressed() -> void:
	if not inventory_item: return
	if is_disabled: return
	item_btn.grab_focus()
	item_selected.emit(inventory_item.item)
	item_btn.focus_mode = Control.FOCUS_ALL

func item_depleted() -> void:
	_disable_slot()

func clear_item() -> void:
	item_btn.focus_mode = Control.FOCUS_NONE
	item_btn.disabled = true

func refresh_ui() -> void:
	# remove everything
	_hide_slot_ui()
	# show hotkey labels
	index_label.text = str(hotkey)
	if not inventory_item: return
	# handle depleted items
	if inventory_item.count > 0: _enable_slot()
	# show numbers if stackable
	if inventory_item.stackable: _show_item_count()

## -- overrides --
func _ready() -> void:
	if inventory_item:	
		var item_icon: TextureRect = inventory_item.item.icon.new_icon_scene()
		item_btn.add_child(item_icon)
	refresh_ui()

## -- helper functions --
func _hide_slot_ui() -> void:
	circle_panel.visible = false

func _show_item_count() -> void:
	circle_panel.visible = true
	item_count.text = str(inventory_item.count)

func _disable_slot() -> void:
	is_disabled = true
	circle_panel.visible = false
	item_btn.focus_mode = Control.FOCUS_NONE
	item_btn.disabled = true

func _enable_slot() -> void:
	is_disabled = false
	item_btn.focus_mode = Control.FOCUS_ALL
	item_btn.disabled = false

func _on_item_btn_pressed() -> void:
	on_btn_pressed()
