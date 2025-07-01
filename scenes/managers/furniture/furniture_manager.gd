extends Node

@export var input_manager: InputManager
@export var tile_manager: TileManager

@onready var equipped_furniture: PackedScene = preload("res://scenes/furniture/small_table.tscn")
var furniture_preview: Furniture
var hovered_tile_coords: Vector2i

func _ready() -> void:
	input_manager.action_pressed.connect(_on_action_pressed)
	tile_manager.new_tile_hovered.connect(_on_new_tile_hovered)
	tile_manager.layer_mouse_out.connect(_on_layer_mouse_out)

## -- helper functions --
func _clear_preview() -> void:
	if furniture_preview:
		furniture_preview.queue_free()
		furniture_preview = null

func _spawn_preview() -> void:
	_clear_preview()
	var preview_ins = equipped_furniture.instantiate()
	preview_ins.configure_preview()
	preview_ins.global_position = tile_manager.get_gp_from_tile_coords(hovered_tile_coords)
	get_tree().root.add_child(preview_ins)
	furniture_preview = preview_ins
	
func _spawn_furnitrue() -> void:
	
	pass

## -- signals --
func _on_new_tile_hovered(tile_coords: Vector2i) -> void:
	if not equipped_furniture: return
	hovered_tile_coords = tile_coords
	_spawn_preview()

func _on_action_pressed(_event: InputEvent) -> void:
	if not equipped_furniture: return
	_spawn_furnitrue()

func _on_layer_mouse_out() -> void:
	_clear_preview()
