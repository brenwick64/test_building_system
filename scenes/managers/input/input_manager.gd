class_name InputManager
extends Node

signal action_pressed(event: InputEvent)
signal action_bar_pressed(number: int)
signal rotate_pressed

func _handle_clicks(event: InputEvent):
	if event.is_action_pressed("Action"): 
		action_pressed.emit(event)

func _handle_action_bar(event: InputEvent):
	var action_bar_map: Dictionary = {
	"ActionBar1": 1,
	"ActionBar2": 2,
	"ActionBar3": 3,
	"ActionBar4": 4,
	"ActionBar5": 5,
	"ActionBar6": 6,
	"ActionBar7": 7,
	"ActionBar8": 8,
	}
	for action_name in action_bar_map.keys():
		if event.is_action_pressed(action_name):
			action_bar_pressed.emit(action_bar_map[action_name])
			return

func _handle_hotkeys(event: InputEvent):
	if event.is_action_pressed("Rotate"):
		rotate_pressed.emit()

func _unhandled_input(event: InputEvent) -> void:
	pass
	_handle_clicks(event)
	_handle_hotkeys(event)
	_handle_action_bar(event)
