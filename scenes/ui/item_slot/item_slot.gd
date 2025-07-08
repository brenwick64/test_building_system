extends PanelContainer

signal item_selected(item: RItem)

@export var item_btn: Button
@export var index_label: Label
@export var circle_panel: Panel
@export var item_count: Label

@export var index: int
@export var inventory_item: RInventoryItem

## -- methods --
func on_btn_pressed() -> void:
	if not inventory_item: return
	item_btn.grab_focus()
	item_selected.emit(inventory_item.item)
	item_btn.focus_mode = Control.FOCUS_ALL

func clear_item() -> void:
	inventory_item = null
	refresh_ui()

func refresh_ui() -> void:
	index_label.text = str(index)
	if inventory_item:
		item_count.text = str(inventory_item.count)
		_show_btn_ui()	
	else:
		_hide_btn_ui()

## -- overrides --
func _ready() -> void:
	if inventory_item:
		var item_icon: TextureRect = inventory_item.item.item_icon_scene.instantiate()
		item_btn.add_child(item_icon)
	refresh_ui()

## -- helper functions --
func _hide_btn_ui() -> void:
	circle_panel.visible = false
	item_btn.visible = false

func _show_btn_ui() -> void:
	if not inventory_item: return
	if inventory_item.stackable:
		circle_panel.visible = true
	item_btn.visible = true

func _on_item_btn_pressed() -> void:
	on_btn_pressed()
