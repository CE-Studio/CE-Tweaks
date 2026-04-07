@tool
extends HSplitContainer


var last:String


func _ready() -> void:
	EditorInterface.get_script_editor().editor_script_changed.connect(scan_script)


func add_issue(sp:String, what:String, sugg := "") -> void:
	pass
	#print(what)


func scan_script(nscript:Script) -> void:
	if nscript.resource_path == last:
		return
	last = nscript.resource_path
	if not nscript is GDScript:
		return
	if not nscript.has_source_code():
		return
	var script:GDScript = nscript
	var source := script.source_code.split("\n")
	if source.size() == 0:
		return
	var licence_line:String = "# " + ProjectSettings.get_setting(&"CE-Tweaks/linter_licence_blurb")
	var licence:String = ProjectSettings.get_setting(&"CE-Tweaks/linter_licence")
	var year:int = Time.get_datetime_dict_from_system().year
	licence_line = licence_line.format({"year":year, "licence":licence})
	if source[0].strip_edges() != licence_line:
		add_issue(script.resource_path, "Line 1: Copyright incorrect or missing!", licence_line)
	for i in source.size():
		var prev_line := source[i - 1].strip_edges()
		var line := source[i].strip_edges()
		if line.begins_with("func "):
			if (not line.begins_with("func _")) and (not prev_line.begins_with("## ")):
				add_issue(script.resource_path, "Line " + str(i + 1) + ": Undocumented function!")
