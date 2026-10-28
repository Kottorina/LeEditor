extends Node
class_name SceneManager


@export var main_editor : MainEditor

@export_group("Ui")
@export var scene_lab : Label
@export var scene_option : OptionButton

@export var scene_add_but : Button
@export var scene_del_but : Button
@export var rename_but : Button

@export var rename_text_edit : TextEdit

@export_group("Managers")

@export var scene_loader : SceneLoader
@export var scene_saver : SceneSaver

func StartBake() -> void:
	if ! scene_option or ! scene_lab or ! scene_add_but or ! scene_del_but or ! rename_but or ! rename_text_edit:
		push_error("Ui Is Null")
		return
	scene_lab.text = UiEditorConst.CurrentScene
	
	if ! scene_option.item_selected.is_connected(LoadSceneFromInd):
		scene_option.item_selected.connect(LoadSceneFromInd)
	
	scene_add_but.text = UiEditorConst.AddSceneBut
	if !scene_add_but.pressed.is_connected(AddNewScene):
		scene_add_but.pressed.connect(AddNewScene.bind(LeSceneFile.new()))
	
	scene_del_but.text = UiEditorConst.DelSceneBut
	if !scene_del_but.pressed.is_connected(DelSelectedScene):
		scene_del_but.pressed.connect(DelSelectedScene)
	
	rename_but.text = UiEditorConst.RenameSceneBut
	if !rename_but.pressed.is_connected(RenameSelectedScene):
		rename_but.pressed.connect(RenameSelectedScene)

var curent_layer : EditorLayer
func LoadLayer( layer : EditorLayer, ind : int = -1 ) -> void:
	
	scene_option.clear()
	
	if layer == null:
		push_error("layer Is Null")
		return
	print("_Load layer: ",layer.resource_name)
	LocalDataKey = layer.resource_name
	curent_layer = layer
	
	local_file_system = LeFileSystem.new()
	
	var editor_save : LeFileSystem = main_editor.GetActualEditorSave()
	if editor_save == null:
		push_warning("editor_save Is Null")
		return
	
	var metadata_obj : Variant = editor_save.GetObjectFromId(
		LocalDataKey,EditorConst.scene_metadata_file_id
		)
	if metadata_obj is int:
		if metadata_obj == LeFileSystem.ObjectIdNotFind:
			var new_metadata := LeScenesMetadataFile.new()
			new_metadata.layer_data_key = layer.resource_name
			local_file_system.AddObjInArray(
				LocalDataKey, new_metadata, EditorConst.scene_metadata_file_id
				)
	elif metadata_obj is LeScenesMetadataFile:
		local_file_system.AddObjInArray(
				LocalDataKey, metadata_obj, EditorConst.scene_metadata_file_id
				)
	else:
		push_error("Metadata ERROR")
		return
	
	var file_scene_ar : Array[LeFile] = editor_save.GetArFromKey(layer.resource_name)
	## ХРУПКАЯ ПРОВЕРКА, НО ПОЛНАЯ ПРОВЕРКА СИЛИШКОМ ДОЛГАЯ
	for scene : LeFile in file_scene_ar:
		if scene is LeSceneFile:
			AddNewScene(scene,scene.id_,false)
	
	var last_ind : int
	if ind == -1:
		last_ind = scene_option.get_selectable_item(true)
	else:
		last_ind = ind
	
	scene_option.select(last_ind)
	LoadSceneFromInd(last_ind)
	
	#scene_option.show_popup() #Проблема В Порядке Инициализации

var local_file_system : LeFileSystem
var LocalDataKey : String

func AddNewScene(scene : LeSceneFile, id : int = -1, is_open : bool = true) -> void: 
	
	var add_scene = scene.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) ## Для ИЗОЛЯЦИИ ПРЕФАБА
	
	if id != -1: ## ТО ЕСТЬ ЕСЛИ МЫ ДОБАВЛЯЕМ УЖЕ СУЩЕСТВУЮУЮ СЦЕНУ
		local_file_system.AddObjInArray(LocalDataKey,add_scene,id, true)
		scene_option.add_item(add_scene.scene_name, id)
	else: ## ТО ЕСТЬ, ЕСЛИ ЭТО СОВЕРШЕННО НОВАЯ СЦЕНА
		var new_id = local_file_system.AddObjInArray(LocalDataKey,add_scene)
		scene_option.add_item(add_scene.scene_name, new_id)
	
	if is_open == true:
		var last_ind : int = scene_option.get_selectable_item(true)
		scene_option.select(last_ind)
		LoadSceneFromInd(last_ind)
		scene_option.show_popup()

func GetSaveContainer() -> SaveContainer:
	if ! curent_layer.baker_rule:
		push_error("curent_layer.baker_rule Is Null")
		return
	if ! scene_saver:
		push_error("Scene Saver ERRROR")
		return
	
	var actual_scene : LeSceneFile = scene_saver.GetActualScene()
	if ! actual_scene:
		push_error("actual_scene Is Null, Save ERROR")
		return
	
	var select_id = scene_option.get_selected_id()
	
	var from_file_scene = local_file_system.GetObjectFromId(LocalDataKey,select_id)
	if from_file_scene is int:
		match from_file_scene:
			LeFileSystem.ERROR:
				push_error("save_scene File System ERROR")
			LeFileSystem.ObjectIdNotFind:
				push_error("save_scene Is ObjectIdNotFind")
		push_error("save_scene ERROR")
	elif from_file_scene is LeSceneFile: 
		actual_scene.id_ = from_file_scene.id_
		actual_scene.scene_name = from_file_scene.scene_name
	
	var from_file_metadata = local_file_system.GetObjectFromId(
		LocalDataKey,EditorConst.scene_metadata_file_id
		)
	if from_file_metadata is int:
		match from_file_metadata:
			LeFileSystem.ERROR:
				push_error("save_scene File System ERROR")
				return
			LeFileSystem.ObjectIdNotFind:
				push_error("save_scene Is ObjectIdNotFind")
				return
		push_error("save_scene ERROR")
		return
	elif from_file_metadata is LeScenesMetadataFile:
		from_file_metadata.scene_import[from_file_scene.id_] = scene_saver.GetValidDataNameArray(
			curent_layer.baker_rule, actual_scene.graph_node_data_ar
			)
		
	var save_container := SaveContainer.new()
	save_container.data_key = LocalDataKey
	
	if actual_scene:
		local_file_system.AddObjInArray(
			LocalDataKey,actual_scene,actual_scene.id_,true
			)
	
	local_file_system.AddObjInArray(
		LocalDataKey,from_file_metadata,EditorConst.scene_metadata_file_id,true
		)
	
	save_container.le_file_ar = local_file_system.GetArFromKey(LocalDataKey)
	return save_container

func DelSelectedScene() -> void:
	
	if scene_option.get_selected() == -1:
		push_warning("get_selected() Is -1")
		return
	
	var select_id = scene_option.get_selected_id()
	local_file_system.DelItemFromId(LocalDataKey, select_id)
	# В теории нужно удалить его напрямую но есть поблема в данных
	
	scene_option.remove_item(scene_option.get_selected())
	
	var last_ind : int = scene_option.get_selectable_item(true)
	scene_option.select(last_ind)
	LoadSceneFromInd(last_ind)
	scene_option.show_popup()

func RenameSelectedScene() -> void:
	
	var selected_idx : int = scene_option.get_selected()
	
	if selected_idx == -1:
		push_warning("get_selected() Is -1")
		return
	
	var new_text : String = rename_text_edit.text
	if not new_text.is_empty():
		
		var select_id = scene_option.get_selected_id()
		
		var scene = local_file_system.GetObjectFromId(LocalDataKey,select_id)
		scene.scene_name = new_text
		local_file_system.AddObjInArray(LocalDataKey,scene,select_id, true)
		
		scene_option.set_item_text(selected_idx,new_text)
		
	else:
		print("SceneManager: Text Is Empty")

func LoadSceneFromInd(ind : int) -> void:
	
	var selected_id = scene_option.get_item_id(ind)
	
	var scene_file = local_file_system.GetObjectFromId(LocalDataKey,selected_id)
	
	if scene_file is int:
		if scene_file == LeFileSystem.ERROR or scene_file == LeFileSystem.ObjectIdNotFind:
			pass # Если понадобиться обработка конкретных ошибок
		push_error("ItemSelected: scene_file Is ObjectIdNotFind Or ERROR")
	elif scene_file is LeSceneFile:
		scene_loader.LoadScene(scene_file)
		
		main_editor.SetSettingValue(EditorSetting.Scene, ind)
	else:
		push_error("ItemSelected: scene_file Is Not LeSceneFile")
