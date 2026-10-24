extends Node

@export var main_editor : MainEditor

func _input(event: InputEvent) -> void:
	if main_editor == null:
		push_error("main_editor Is Null")
		return
	
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_S and event.ctrl_pressed:
			main_editor.SaveCurrentEditorData()
		
		elif event.keycode == KEY_E and event.ctrl_pressed:
			main_editor.ExportCurentScene()
