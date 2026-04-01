@tool
extends PanelContainer


const BOOKMARKS = "CE-Tweaks/bookmarks"
const COLORS = "CE-Tweaks/bookmark_colors"


var items:PackedStringArray = []
var button_list:HBoxContainer


func _add_pressed() -> void:
	EditorInterface.popup_quick_open(_add_item, [&"PackedScene"])


func _add_item(item:String) -> void:
	if item != "":
		var sitems := PackedStringArray(ProjectSettings.get_setting(BOOKMARKS, items))
		sitems.append(item)
		ProjectSettings.set_setting(BOOKMARKS, sitems)
		var scols := PackedColorArray(ProjectSettings.get_setting(COLORS))
		if scols.size() < sitems.size():
			while scols.size() < sitems.size():
				scols.append(Color.WHITE)
			ProjectSettings.set_setting(COLORS, scols)
		ProjectSettings.save()


func _settings_changed() -> void:
	var sitems := PackedStringArray(ProjectSettings.get_setting(BOOKMARKS, items))
	if items != sitems:
		var scols := PackedColorArray(ProjectSettings.get_setting(COLORS))
		while scols.size() < sitems.size():
			scols.append(Color.WHITE)
		items = PackedStringArray(sitems)
		for i in button_list.get_children():
			i.queue_free()
		for i in items.size():
			var b:Button = preload("uid://dtlw277icxep0").instantiate()
			b.scn = items[i]
			b.modulate = scols[i]
			b.idx = i
			button_list.add_child(b)



func _enter_tree() -> void:
	button_list = $HBoxContainer/HBoxContainer
	if not ProjectSettings.settings_changed.is_connected(_settings_changed):
		ProjectSettings.settings_changed.connect(_settings_changed)
	_settings_changed()
