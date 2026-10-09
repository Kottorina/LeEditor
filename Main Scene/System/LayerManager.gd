extends Node

@export var main_editor : Node

@export_group("System")
@export var scene_manager : Node

@export_group("Ui")
@export var layer_lab : Label
@export var layer_option : OptionButton

var item_ar : Array[EditorObjectLayer]

func StartBake() -> void:
	if ! main_editor or ! layer_lab or ! layer_option:
		push_error("LayerManager StartBake ERROR")
		return
	
	layer_lab.text = UiEditorConst.CurentLayer
	
	item_ar.clear()
	layer_option.clear()
	
	var layer_ar : Array = main_editor.GetArEditorlayers()
	for layer : EditorObjectLayer in layer_ar:
		layer_option.add_item(layer.data_key,item_ar.size())
		item_ar.append(layer)
	
	if ! layer_option.item_selected.is_connected(ItemSelected):
		layer_option.item_selected.connect(ItemSelected)
	
	var current_id = main_editor.GetSettingValue(EditorSetting.Layer)
	layer_option.select(current_id)

func ItemSelected(id : int) -> void:
	main_editor.SetSettingValue(EditorSetting.Layer, id)
