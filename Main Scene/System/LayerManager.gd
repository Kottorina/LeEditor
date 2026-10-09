extends Node
class_name LayerManager

@export var main_editor : MainEditor

@export_group("System")
@export var scene_manager : SceneManager

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
	ItemSelected(current_id)

func ItemSelected(id : int) -> void:
	
	if ! main_editor or ! scene_manager:
		push_error("ItemSelected ERROR")
		return
	
	if item_ar.size() < id:
		push_error("Id In LayerManager Is Too Big")
		return
	
	main_editor.SetSettingValue(EditorSetting.Layer, id)
	scene_manager.LoadLayer( item_ar[id] )
