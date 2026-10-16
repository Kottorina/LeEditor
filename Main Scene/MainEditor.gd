extends Node
class_name MainEditor

var editor_data : LeFileSystem
@export var editor_setting : EditorSetting ## ДЛЯ СОХРАНЕНИЯ СОСТОЯНИЯ РЕДАКТОРА

@export var editor_layer_dir_path : String = "res://addons/LeEditor/Objects/Layers/Editor"
@export var graph_node_main_instr_path : String = "res://addons/LeEditor/Objects/Ui Instr/"
@export var link_layer_dir_path : String = "res://addons/LeEditor/Objects/Layers/Link"


@export_group("System")
@export var system_ar : Array[Node]

@export_group("ui")
@export var FileNameLab : Label

func _ready() -> void:
	
	## ВРЕМЯ НА ПОДГОТОВКУ ДЛЯ GraphEdit, без нее выдает некоретные результаты
	await get_tree().process_frame
	
	if ! editor_setting or ! FileNameLab:
		push_error("LOAD editor_setting ERROR")
		return
	
	FileNameLab.text = UiEditorConst.Empty
	LoadEditorData(editor_setting.path_to_editor_data)
	
	for system : Node in system_ar:
		var cal := Callable(system,EditorConst.StartBake)
		if cal.is_valid():
			cal.call()
		else:
			print(system.name," Dont Have", EditorConst.StartBake)
	
func GetArrayFromScriptAndDir( path : String, find_script : Script ) -> Array:
	var dir = DirAccess.open(path)
	if !dir:
		return []
	var return_ar : Array = []
	var files_name = dir.get_files()
	for file_name in files_name:
		var full_path = path.path_join(file_name)
		var file = load(full_path)
		if file.get_script() == find_script:
			file.resource_name = file_name.trim_suffix(".tres")
			return_ar.append(file)
	return return_ar

func GetArEditorlayers() -> Array:
	var ar = GetArrayFromScriptAndDir( editor_layer_dir_path, EditorLayer )
	return ar

func GetArGraphNodeInstrUiInstr() -> Array:
	var ar = GetArrayFromScriptAndDir( graph_node_main_instr_path, GraphNodeMainInstr )
	return ar


func LoadEditorData( path : String ) -> void:
	var load_node : Variant
	if FileAccess.file_exists(path):
		load_node = ResourceLoader.load( path,"",ResourceLoader.CACHE_MODE_IGNORE )
		if load_node is LeFileSystem:
			FileNameLab.text = path.get_file()
			editor_data = load_node
			editor_setting.path_to_editor_data = path
			SaveEditorSetting() 
			
			return
	push_warning("Load LeFileSystem ERROR")


func NewPath() -> void:
	var file_dial = FileDialog.new()
	file_dial.use_native_dialog = true
	file_dial.access = FileDialog.ACCESS_FILESYSTEM
	file_dial.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dial.file_selected.connect(LoadEditorData)
	file_dial.show()

func GetSettingValue(data_key : String) -> Variant:
	if ! editor_setting:
		push_error("editor_setting Is Null")
		return
	return editor_setting.get(data_key)
func SetSettingValue(data_key : String, value : Variant) -> void:
	if ! editor_setting:
		push_error("editor_setting Is Null")
		return
	editor_setting.set(data_key,value)
	SaveEditorSetting()

func GetActualEditorSave() -> LeFileSystem:
	if editor_data:
		return editor_data
	return 

##СОХРАНЯЕТ ФАЙЛ ДАННЫХ LeFileSystem
func SaveCurrentEditorData() -> void:
	var editor_data = GetActualEditorSave()
	if ! editor_data or ! editor_setting.path_to_editor_data:
		push_error("editor_data Save ERROR")
		return
	
	for system : Node in system_ar:
		var cal := Callable(system,EditorConst.GetSaveContainer)
		if cal.is_valid():
			var save_cont : SaveContainer = cal.call()
			editor_data.RewritingCategory(save_cont.data_key,save_cont.le_file_ar)
		else:
			print(system.name," Dont Have ", EditorConst.GetSaveContainer)
	
	ResourceSaver.save(editor_data, editor_setting.path_to_editor_data)
## СОХРАНЯЕТ ФАЙЛ НАСТРОЕК
func SaveEditorSetting() -> void:
	if ! editor_setting:
		push_error("editor_setting Is Null")
		return 
	ResourceSaver.save(editor_setting)

#Array[EditorObjectLayer] ## Для обработки разных данных 
#: Array[PathNode] ## Для обработки зависимостей
#@export_group("Managers")
#@export var file_save_load : Node
#@export var path_manager : Node
#
### БАЗОВЫЕ НАСТРОЙКИ
#func _ready() -> void:
	#file_save_load.edditor_save_data = editor_save_data
	#path_manager.UpdateBaseUi(path_obj_layer)
