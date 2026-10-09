extends Node
class_name SceneManager


@export var main_editor : MainEditor

@export_group("Ui")
@export var scene_lab : Label
@export var scene_option : OptionButton

@export var scene_add_but : Button
@export var scene_del_but : Button

var id_to_file : Dictionary

func StartBake() -> void:
	if ! scene_lab or ! scene_add_but or ! scene_del_but:
		push_error("Ui Is Null")
		return
	scene_lab.text = UiEditorConst.CurrentScene
	
	scene_add_but.text = UiEditorConst.AddSceneBut
	if !scene_add_but.pressed.is_connected(AddNewScene):
		scene_add_but.pressed.connect(AddNewScene.bind(LeSceneFile.new()))
	
	scene_del_but.text = UiEditorConst.DelSceneBut
	if !scene_del_but.pressed.is_connected(DelSelectedScene):
		scene_del_but.pressed.connect(DelSelectedScene)

func LoadLayer( layer : EditorObjectLayer ) -> void:
	
	id_to_file.clear()
	scene_option.clear()
	local_file_system = LeFileSystem.new()
	
	if layer == null:
		push_error("layer Is Null")
		return
	print("Load layer: ",layer.data_key)
	
	var editor_save : LeFileSystem = main_editor.GetActualEditorSave()
	if editor_save == null:
		push_warning("editor_save Is Null")
		return
	
	LocalDataKey = layer.data_key
	
	var file_scene_ar : Array[LeFile] = editor_save.GetArFromKey(layer.data_key)
	## ХРУПКАЯ ПРОВЕРКА, НО ПОЛНАЯ ПРОВЕРКА СИЛИШКОМ ДОЛГАЯ
	for scene : LeSceneFile in file_scene_ar:
		AddNewScene(scene,scene.id_)

var local_file_system : LeFileSystem
var LocalDataKey : String
func AddNewScene(scene : LeSceneFile, id : int = -1) -> void: 
	
	var add_scene = scene.duplicate_deep(Resource.DEEP_DUPLICATE_ALL) ## Для ИЗОЛЯЦИИ ПРЕФАБА
	
	if id != -1: ## ТО ЕСТЬ ЕСЛИ МЫ ДОБАВЛЯЕМ УЖЕ СУЩЕСТВУЮУЮ СЦЕНУ
		local_file_system.AddNewObjInArray(LocalDataKey,add_scene,id)
		id_to_file[id] = add_scene
		scene_option.add_item(add_scene.scene_name, id)
	else: ## ТО ЕСТЬ, ЕСЛИ ЭТО СОВЕРШЕННО НОВАЯ СЦЕНА
		var new_id = local_file_system.AddNewObjInArray(LocalDataKey,add_scene)
		id_to_file[new_id] = add_scene
		scene_option.add_item(add_scene.scene_name, new_id)
	
	scene_option.select(scene_option.get_selectable_item(true))
	scene_option.show_popup()
	# И ЗАРУЗИТЬ БЛЯДЬ !!!

func GetSaveContainer() -> SaveContainer:
	var save_container := SaveContainer.new()
	save_container.data_key = LocalDataKey
	save_container.le_file_ar = local_file_system.GetArFromKey(LocalDataKey)
	return save_container

func DelSelectedScene() -> void:
	
	if scene_option.get_selected() == -1:
		push_warning("get_selected() Is -1")
		return
	
	var select_id = scene_option.get_selected_id()
	id_to_file.erase(select_id)
	local_file_system.DelItemFromId(LocalDataKey, select_id)
	
	scene_option.remove_item(scene_option.get_selected())
	
	scene_option.select(scene_option.get_selectable_item(true))
	scene_option.show_popup()
	# И ЗАРУЗИТЬ БЛЯДЬ !!!
