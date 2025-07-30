extends PanelContainer

signal item_selected(item_id: String)

@export var hotkey: String
@export var item_id: String
@export var parent_action_bar: Panel

@export var item_btn: Button
@export var hotkey_label: Label
@export var circle_panel: Panel
@export var item_count: Label

var is_disabled: bool = false

## -- methods --	
func clear_item() -> void:
	item_btn.focus_mode = Control.FOCUS_NONE
	item_btn.disabled = true
	
func add_icon() -> void:
	_show_hotkey()
	if not item_id: return
	var item_data: RItemData = ItemsDB.get_item_data(item_id)
	if not item_data: return
	var item_icon: TextureRect = item_data.icon.new_icon_scene()
	item_btn.add_child(item_icon)

func refresh_ui() -> void:
	circle_panel.visible = false
	# populate fields depending on item
	if not item_id:
		_hide_all()
		return
	var inventory_item: RInventoryItem = parent_action_bar.inventory.get_item(item_id)
	if inventory_item: 
		if inventory_item.stackable: _show_item_count(inventory_item)
		_enable_slot()
	else:
		_disable_slot()

## -- overrides --
func _ready() -> void:
	add_icon()
	refresh_ui()

## -- helper functions --
func _hide_all() -> void:
	item_btn.visible = false
	circle_panel.visible = false

func _show_hotkey() -> void:
	hotkey_label.text = str(hotkey)

func _show_item_count(inventory_item: RInventoryItem) -> void:
	var old_item_count: int = int(item_count.text)
	var is_count_increased: bool = old_item_count < inventory_item.count
	
	circle_panel.visible = true
	item_count.text = str(inventory_item.count)

	if is_count_increased:
		UIEffects.bounce_control(circle_panel)

func _disable_slot() -> void:
	is_disabled = true
	circle_panel.visible = false
	item_btn.focus_mode = Control.FOCUS_NONE
	item_btn.disabled = true
	if item_btn.get_children():
		var item_btn_label: TextureRect = item_btn.get_children()[0]
		item_btn_label.material.set_shader_parameter("use_grayscale", true)

func _enable_slot() -> void:
	is_disabled = false
	item_btn.focus_mode = Control.FOCUS_ALL
	item_btn.disabled = false
	item_btn.visible = true
	if item_btn.get_children():
		var item_btn_label: TextureRect = item_btn.get_children()[0]
		item_btn_label.material.set_shader_parameter("use_grayscale", false)

## -- handlers --
func handle_btn_pressed() -> void:
	_on_item_btn_pressed()
	
func handle_item_depleted() -> void:
	_disable_slot()

## -- signals --
func _on_item_btn_pressed() -> void:
	if not item_id: return
	if is_disabled: return
	item_btn.grab_focus()
	item_selected.emit(item_id)
	item_btn.focus_mode = Control.FOCUS_ALL
