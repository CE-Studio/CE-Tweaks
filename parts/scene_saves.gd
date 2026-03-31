@tool
extends PanelContainer


const SETTING_NAME = "CE-Tweaks/bookmarks"


var items:PackedStringArray = []
var button_list:HBoxContainer


func _add_pressed() -> void:
	EditorInterface.popup_quick_open(_add_item, [&"PackedScene"])


func _add_item(item:String) -> void:
	if item != "":
		var sitems := PackedStringArray(ProjectSettings.get_setting(SETTING_NAME, items))
		sitems.append(item)
		ProjectSettings.set_setting(SETTING_NAME, sitems)
		print(sitems)


func _settings_changed() -> void:
	var sitems:PackedStringArray = ProjectSettings.get_setting(SETTING_NAME, items)
	if items != sitems:
		items = PackedStringArray(sitems)
		for i in button_list.get_children():
			i.queue_free()
		for i in items:
			var b:Button = preload("uid://dtlw277icxep0").instantiate()
			b.scn = i
			button_list.add_child(b)



func _enter_tree() -> void:
	button_list = $HBoxContainer/HBoxContainer
	ProjectSettings.settings_changed.connect(_settings_changed)
	_settings_changed()
