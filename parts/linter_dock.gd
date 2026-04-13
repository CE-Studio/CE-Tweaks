@tool
extends HSplitContainer


@onready var errorlist:VBoxContainer = $ScrollContainer/VBoxContainer


var last:String
var running := false


func _ready() -> void:
	if running:
		EditorInterface.get_script_editor().editor_script_changed.connect(scan_script)


func add_issue(sp:String, what:String, lnum:int, sugg := "") -> void:
	var lbl := Button.new()
	lbl.text = sp + "\n" + what + "\n" + sugg
	lbl.alignment = HORIZONTAL_ALIGNMENT_LEFT
	lbl.set_meta(&"pth", sp)
	lbl.pressed.connect(_nav_to.bind(sp, lnum))
	errorlist.add_child(lbl)
	errorlist.move_child(lbl, 0)


func _nav_to(pth:String, pos:int) -> void:
	if FileAccess.file_exists(pth):
		EditorInterface.edit_script(load(pth), pos)


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
	for i in errorlist.get_children():
		if i.has_meta(&"pth"):
			if i.get_meta(&"pth") == last:
				i.queue_free()
	if source.size() == 0:
		return
	var licence_line:String = "# " + ProjectSettings.get_setting(&"CE-Tweaks/linter_licence_blurb")
	var licence:String = ProjectSettings.get_setting(&"CE-Tweaks/linter_licence")
	var year:int = Time.get_datetime_dict_from_system().year
	licence_line = licence_line.format({"year":year, "licence":licence})
	if source[0].strip_edges() != licence_line:
		add_issue(script.resource_path, "Line 1: Copyright incorrect or missing!", 1, licence_line)
	for i in source.size():
		var prev_line := source[i - 1].strip_edges()
		var line := source[i].strip_edges()
		if line.begins_with("func "):
			if (not line.begins_with("func _")) and (not prev_line.begins_with("## ")):
				add_issue(script.resource_path, "Line " + str(i + 1) + ": Undocumented function!", i + 1)
		elif line.begins_with("static func "):
			if (not line.begins_with("static func _")) and (not prev_line.begins_with("## ")):
				add_issue(script.resource_path, "Line " + str(i + 1) + ": Undocumented static function!", i)
		else:
			line = source[i]
			if line.begins_with("var "):
				if (not line.begins_with("var _")) and (not prev_line.begins_with("## ")):
					add_issue(script.resource_path, "Line " + str(i + 1) + ": Undocumented variable!", i + 1)
			elif line.begins_with("static var "):
				if (not line.begins_with("static var _")) and (not prev_line.begins_with("## ")):
					add_issue(script.resource_path, "Line " + str(i + 1) + ": Undocumented static variable!", i + 1)


func _on_clear_pressed() -> void:
	for i in errorlist.get_children():
		if i.has_meta(&"pth"):
			i.queue_free()


func _on_scan_pressed() -> void:
	_on_clear_pressed()
	_recur_scan("res://")


func _recur_scan(pth:String) -> void:
	print(pth)
	for i in DirAccess.get_directories_at(pth):
		if (pth == "res://") and ((i == "addons") or (i == "artassets")):
			continue
		if pth == "res://":
			_recur_scan(pth + i)
		else:
			_recur_scan(pth + "/" + i)
	for i in DirAccess.get_files_at(pth):
		if i.get_extension() == "gd":
			var s:RefCounted
			if pth == "res://":
				s = load(pth + i)
			else:
				s = load(pth + "/" + i)
			if s is GDScript:
				scan_script(s)
