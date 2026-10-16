extends Node
class_name LayerUiNodeManager

@export_group("Managers")
@export var main_editor : MainEditor
@export var graph_manager : GraphManager

## ПОДГРУЖАЕТ ТАБЛИЦУ С ДИСКА, БАЗОВОЕ И ОПРЕДЕЛЕННОЕ
func StartBake() -> void:
	
	if ! main_editor:
		push_error("main_editor Is Null")
		return
	
	var graph_node_main_instr GetArGraphNodeInstrUiInstr

## СОЗДАЕТ И ЗАГРУЖАЕТ ФИНАЛЬНыЙ СПИСОК И ПОДГРУЖАЕТ ДАННЫЕ ИСХОДЯ ИЗ НАСТРОЕК СЦЕНЫ 
## И УЖЕ ОТДАЕТ В РЕДАКТОР
func LoadLayerUI( layer : EditorLayer ) -> void:
	print("_Load Ui Layer For: ",layer.data_key)
	
	if ! graph_manager:
		push_error("graph_manager Is Null")
		return
	
	graph_manager.ClearAddNodePopup()
	
