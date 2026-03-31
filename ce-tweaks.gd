# Copyright 2026 CE-Studio: LGPL-3.0-only
@tool
extends EditorPlugin


const SETTING_NAME = "CE-Tweaks/bookmarks"
const SETTING_DEFAULT:PackedStringArray = []


var buttons:PanelContainer


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree():
	if not ProjectSettings.has_setting(SETTING_NAME):
		ProjectSettings.set_setting(SETTING_NAME, SETTING_DEFAULT)
	ProjectSettings.set_initial_value(SETTING_NAME, SETTING_DEFAULT)
	if not is_instance_valid(buttons):
		var b := EditorInterface.get_base_control()
		var button_parent:HBoxContainer = b.get_child(0).get_child(0).get_child(4).get_child(0)
		buttons = preload("uid://c428nc5q7j8vs").instantiate()
		button_parent.add_child(buttons)
		button_parent.move_child(buttons, 0)



func _exit_tree() -> void:
	if is_instance_valid(buttons):
		buttons.queue_free()
