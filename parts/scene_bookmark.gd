@tool
extends Button


const COLORS = "CE-Tweaks/bookmark_colors"


var scn := ""
var idx:int


func _enter_tree() -> void:
	if not ProjectSettings.settings_changed.is_connected(_recol):
		ProjectSettings.settings_changed.connect(_recol)
	tooltip_text = scn


func _recol() -> void:
	var scols := PackedColorArray(ProjectSettings.get_setting(COLORS))
	if scols.size() >= idx:
		modulate = scols[idx]


func _pressed() -> void:
	if not EditorInterface.is_playing_scene():
		EditorInterface.play_custom_scene(scn)
