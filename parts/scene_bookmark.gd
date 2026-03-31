@tool
extends Button


var scn := ""


func _enter_tree() -> void:
	tooltip_text = scn


func _pressed() -> void:
	if not EditorInterface.is_playing_scene():
		EditorInterface.play_custom_scene(scn)
