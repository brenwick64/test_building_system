class_name UICraftingMenu
extends Panel

@export var title: String
@export var recipe_tags: Array[String]
@export var crafting_manager: CraftingManager
@export var crafting_station: CraftingStation

@onready var recipes_rg: ResourceGroup = preload("res://resource_groups/recipes.tres")
@onready var recipe_ui_scene: PackedScene = preload("res://scenes/ui/ui_crafting_menu/crafting_recipe/crafting_recipe.tscn")

@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var menu_title: Label = $MarginContainer/VBoxContainer/MenuTitle

var recipes_arr: Array[RRecipe]
var inventory_items: Array[RInventoryItem]

## -- overrides --
func _ready() -> void:
	menu_title.text = title
	recipes_rg.load_all_into(recipes_arr)
	recipes_arr = _filter_recipes_by_tag(recipes_arr)
	recipes_arr.sort_custom(_compare_input_item_count)
	for recipe: RRecipe in recipes_arr:
		var recipe_ui: Control = recipe_ui_scene.instantiate()
		recipe_ui.recipe = recipe
		recipe_ui.craft_pressed.connect(_on_craft_pressed)
		v_box_container.add_child(recipe_ui)
	_check_inventory(inventory_items)

## -- helper functions --
func _filter_recipes_by_tag(recipes: Array[RRecipe]) -> Array[RRecipe]:
	if recipe_tags.is_empty(): return recipes
	return recipes.filter(func(r: RRecipe) -> bool:
		return r and r.recipe_tags and recipe_tags.any(func(tag): return r.recipe_tags.has(tag))
	)

func _check_inventory(inv_items: Array[RInventoryItem]) -> void:
	for child: Node in v_box_container.get_children():
		if child is not UICraftingRecipe: continue
		child.check_inventory(inv_items)

func _on_craft_pressed(recipe: RRecipe) -> void:
	if not crafting_station:
		push_error("ui_crafting_menu error: attempting to craft without current crafting station")
		return
	crafting_manager.handle_craft(recipe, crafting_station)

func _compare_input_item_count(a: RRecipe, b:RRecipe) -> int:
	var count_a: int = a.input_items.size()
	var count_b: int = b.input_items.size()
	
	if count_a > count_a: return 1      # a is larger
	elif count_a < count_b: return -1   # b is larger
	else: return 0                      # equal

## -- signals --
func _on_inventory_updated(inv_items: Array[RInventoryItem]) -> void:
	inventory_items = inv_items
	_check_inventory(inventory_items)
