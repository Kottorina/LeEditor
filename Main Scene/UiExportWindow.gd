extends Window

@export_group("Ui")

@export var title_label : Label
@export var final_export_button : Button

@export var is_recursive_link_check : CheckBox

func StartBake() -> void:
	if ! title_label or ! final_export_button or ! is_recursive_link_check:
		push_error("StartBake ERROR")
		return
	
	title_label.text = UiEditorConst.Export
	final_export_button.text = UiEditorConst.StartExport
	
	is_recursive_link_check.text = UiEditorConst.ExportIsRecursiveLink

#func MakeUi() -> void:
	#
