extends Node
class_name LayerUiNodeManager

@export_group("Managers")
@export var main_editor : MainEditor
@export var graph_manager : GraphManager

var graph_node_main_inst_dict : Dictionary

## ПОДГРУЖАЕТ ТАБЛИЦУ С ДИСКА, БАЗОВОЕ И ОПРЕДЕЛЕННОЕ
func StartBake() -> void:
	
	if ! main_editor:
		push_error("main_editor Is Null")
		return
	
	graph_node_main_inst_dict.clear()
	
	var graph_node_main_inst_ar : Array = main_editor.GetArGraphNodeInstrUiInstr()
	for instr : GraphNodeMainInstr in graph_node_main_inst_ar:
		graph_node_main_inst_dict[instr.resource_name] = instr

## СОЗДАЕТ И ЗАГРУЖАЕТ ФИНАЛЬНыЙ СПИСОК И ПОДГРУЖАЕТ ДАННЫЕ ИСХОДЯ ИЗ НАСТРОЕК СЦЕНЫ 
## И УЖЕ ОТДАЕТ В РЕДАКТОР
func LoadLayerUI( layer : EditorLayer ) -> void:
	print("_Load Ui Layer For: ",layer.data_key)
	
	if ! graph_manager:
		push_error("graph_manager Is Null")
		return
	
	graph_manager.ClearAddNodePopup()
	
	var propety_ar : Array[String] = layer.GetUiSettingNameAr()
