extends Node
class_name UiNodeManager

@export_group("Managers")
@export var main_editor : MainEditor
@export var graph_manager : GraphManager
@export var ui_node_maker : UiNodeMaker

var graph_node_main_inst_dict : Dictionary
var id_to_graph_node_main_instr : Dictionary

var empty_instruction_key : String

## ПОДГРУЖАЕТ ТАБЛИЦУ С ДИСКА, БАЗОВОЕ И ОПРЕДЕЛЕННОЕ
func StartBake() -> void:
	if ! main_editor:
		push_error("main_editor Is Null")
		return

	graph_node_main_inst_dict.clear()
	
	var graph_node_main_inst_ar : Array = main_editor.GetArGraphNodeInstrUiInstr()
	for instr : GraphNodeMainInstr in graph_node_main_inst_ar:
		var new_instr : GraphNodeMainInstr = instr.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
		
		new_instr.instruction_key = instr.resource_name
		graph_node_main_inst_dict[new_instr.instruction_key] = new_instr
	
	if ! main_editor.empty_graph_node_instr:
		push_warning("empty_graph_node_instr Is Null In StartBake")
		return
	
	var empty_instr : GraphNodeMainInstr = main_editor.empty_graph_node_instr
	empty_instruction_key = empty_instr.resource_path.get_file().get_basename()
	empty_instr.instruction_key = empty_instruction_key
	graph_node_main_inst_dict[empty_instr.instruction_key] = empty_instr
	
## СОЗДАЕТ И ЗАГРУЖАЕТ ФИНАЛЬНыЙ СПИСОК И ПОДГРУЖАЕТ ДАННЫЕ ИСХОДЯ ИЗ НАСТРОЕК СЦЕНЫ 
## И УЖЕ ОТДАЕТ В РЕДАКТОР
func LoadLayerUI( layer : EditorLayer ) -> void:
	print("_Load Ui Layer For: ",layer.data_key)
	
	if ! graph_manager:
		push_error("graph_manager Is Null")
		return
	
	id_to_graph_node_main_instr.clear()
	graph_manager.ClearAddNodePopup()
	
	var ui_node_name_ar : Array[String] = layer.GetUiGraphNodeInstrKeys()
	for ui_node_name in ui_node_name_ar:
		
		if graph_node_main_inst_dict.has(ui_node_name):
			var ui_node_main : GraphNodeMainInstr = graph_node_main_inst_dict[ui_node_name]
			if ui_node_main is GraphNodeMainInstr:
				var ui_popup_id : int = graph_manager.ExpandAddNodePopup(
					UiEditorConst.UiAddNodeCategory[ui_node_main.ui_category],
					UiEditorConst.UiGraphNodeMainTitle[ui_node_main.type]
					)
				if ui_popup_id == GraphManager.EmptyId:
					push_error("New id Is Empty")
					return
				
				id_to_graph_node_main_instr[ui_popup_id] = ui_node_main
		else:
			push_warning("ui_node_name Not Has graph_node_main_inst_dict")

func FromInstructionKeyToGraphNodeMainInstr( instruction_key : String) -> GraphNodeMainInstr:
	if graph_node_main_inst_dict.has(instruction_key):
		return graph_node_main_inst_dict[instruction_key]
	push_warning("instruction_key Is Null")
	if graph_node_main_inst_dict.has(empty_instruction_key):
		return graph_node_main_inst_dict[empty_instruction_key]
	push_warning("empty_instruction_key Is Null")
	return
	
func FromIdAndCoordMakeNewUiNode(id : int, coord : Vector2 = Vector2.ZERO) -> void:
	if ! ui_node_maker:
		push_error("ui_node_maker Is Null")
		return
	
	var ui_node = id_to_graph_node_main_instr[id]
	
	if ui_node is GraphNodeMainInstr:
		ui_node_maker.MakeNewGraphNode(ui_node, coord)
	else:
		push_error("ui_node Is Not GraphNodeMainInstr")
		return
