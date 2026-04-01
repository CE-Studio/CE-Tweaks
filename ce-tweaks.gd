# Copyright 2026 CE-Studio: LGPL-3.0-only
@tool
extends EditorPlugin


const _EPACKED:PackedStringArray = []
const _CEPACKED:PackedColorArray = []

const SETTINGS = [
	["CE-Tweaks/bookmarks", _EPACKED],
	["CE-Tweaks/bookmark_colors", _CEPACKED],
]


var buttons:PanelContainer


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree():
	for i in SETTINGS:
		if not ProjectSettings.has_setting(i[0]):
			ProjectSettings.set_setting(i[0], i[1])
		ProjectSettings.set_initial_value(i[0], i[1])
	if not is_instance_valid(buttons):
		var b := EditorInterface.get_base_control()
		var button_parent:HBoxContainer = b.get_child(0).get_child(0).get_child(4).get_child(0)
		buttons = preload("uid://c428nc5q7j8vs").instantiate()
		button_parent.add_child(buttons)
		button_parent.move_child(buttons, 0)



func _exit_tree() -> void:
	if is_instance_valid(buttons):
		buttons.queue_free()
