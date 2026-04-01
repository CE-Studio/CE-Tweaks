@tool
extends HSplitContainer


var last:String


func _ready() -> void:
	EditorInterface.get_script_editor().editor_script_changed.connect(scan_script)


func scan_script(nscript:Script) -> void:
	if nscript.resource_path == last:
		return
	last = nscript.resource_path
	if not nscript is GDScript:
		return
	if not nscript.has_source_code():
		return
	var script:GDScript = nscript
	print(script.source_code)
