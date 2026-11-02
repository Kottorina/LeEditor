extends Node
class_name LayerManager

@export var main_editor : MainEditor

@export_group("System")
@export var scene_manager : SceneManager
@export var ui_manager : UiNodeManager

@export_group("Ui")
@export var layer_lab : Label
@export var layer_option : OptionButton

var item_ar : Array[EditorLayer]

func StartBake() -> void:
	if ! main_editor or ! layer_lab or ! layer_option:
		push_error("LayerManager StartBake ERROR")
		return
	
	layer_lab.text = UiEditorConst.CurentLayer
	
	item_ar.clear()
	layer_option.clear()
	
	var layer_ar : Array = main_editor.GetArEditorlayers()
	for layer : EditorLayer in layer_ar:
		layer_option.add_item(layer.resource_name,item_ar.size())
		item_ar.append(layer)
	
	if ! layer_option.item_selected.is_connected(ItemSelected):
		layer_option.item_selected.connect(ItemSelected)
	
	if ! scene_manager:
		push_error("scene_manager ERROR")
		return
	
	var current_id = main_editor.GetSettingValue(EditorSetting.Layer)
	
	if item_ar.size() < current_id:
		push_warning("Id In LayerManager Load Setting Is Too Big")
		return
	

	layer_option.select(current_id)
	
	StartLoadLayer( item_ar[current_id], GetCurentSceneId(item_ar[current_id].resource_name) )

const ArrayMetadataGoodSize : int = 1

func GetCurentSceneId( data_key : String ) -> int:
	var cur_metadata_ar = main_editor.GetActualEditorSave().FindFile(
		LeScenesMetadataFile,data_key
		)
	var current_ind_scene : int = NullSceneId
	if cur_metadata_ar is Array:
		if cur_metadata_ar.size() == ArrayMetadataGoodSize:
			current_ind_scene = cur_metadata_ar.pop_back().curent_scene_id
	return current_ind_scene

func ItemSelected(id : int) -> void:
	if item_ar.size() < id:
		push_error("Id In LayerManager Is Too Big")
		return
	
	main_editor.SaveCurrentEditorData() ## Что бы не терять данные при переключение слоев
	main_editor.SetSettingValue(EditorSetting.Layer, id)
	
	StartLoadLayer(item_ar[id], GetCurentSceneId(item_ar[id].resource_name))

const NullSceneId : int = -1
func StartLoadLayer( layer : EditorLayer, scene_ind : int = NullSceneId) -> void:
	if ! ui_manager or ! scene_manager:
		push_error("ItemSelected ERROR")
		return
	
	ui_manager.LoadLayerUI( layer )
	scene_manager.LoadLayer( layer, scene_ind )
	
