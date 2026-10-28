extends Node
class_name UiNodeManager

@export_group("Managers")
@export var main_editor : MainEditor
@export var add_node_popup_manager : AddNodePopupManager
@export var ui_node_maker : UiNodeMaker

var graph_node_main_inst_dict : Dictionary ## Общие Инструкции
var layer_graph_node_main_inst_dict : Dictionary ## Временные Инструкции Из Слоя

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
	
	if ! main_editor.UpdateEditorSave.is_connected(
			UpdateLayerGraphNodeMainInstrDict
			):
		main_editor.UpdateEditorSave.connect(
			UpdateLayerGraphNodeMainInstrDict
			)
	UpdateLayerGraphNodeMainInstrDict()
	
func UpdateLayerGraphNodeMainInstrDict() -> void:
	
	layer_graph_node_main_inst_dict.clear()
	
	if ! main_editor:
		push_error("main_editor Is Null")
		return
	var curent_editor_save = main_editor.GetActualEditorSave()
	if ! curent_editor_save:
		push_error("curent_editor_save Is Null")
		return
	
	var all_metadata_scen_file = curent_editor_save.FindFile(
		LeScenesMetadataFile
		)
	
	for metadata_file : LeScenesMetadataFile in  all_metadata_scen_file:
		for scene_metadata_key in metadata_file.scene_import.keys():
			for start_link in metadata_file.scene_import[scene_metadata_key]:
				var unic_instruction_key : String = str(
					metadata_file.layer_data_key, UiEditorConst.UiSplitChar,
					scene_metadata_key, UiEditorConst.UiSplitChar,
					start_link
					)
				var new_graph_node_main_instr := GraphNodeMainInstr.new()
				new_graph_node_main_instr.type = EditorConst.GraphNodeType.MakeMetadataLink
				new_graph_node_main_instr.instruction_key = unic_instruction_key
				new_graph_node_main_instr.ui_category = UiEditorConst.EnumAddNodeCategory.Tool
				
				new_graph_node_main_instr.is_custom_title = IsConstLayerTrue
				new_graph_node_main_instr.custom_title = unic_instruction_key
				
				var new_graph_node_layer_instr := GraphNodeLayerInstr.new()
				
				new_graph_node_layer_instr.body_data_key = EditorConst.DataKey.FirstData
				new_graph_node_layer_instr.body_node = EditorConst.BodyNode.Label_
				
				new_graph_node_layer_instr.is_left = OpenConnector
				new_graph_node_layer_instr.is_right = OpenConnector
				
				new_graph_node_main_instr.layer_instr_ar.append(
					new_graph_node_layer_instr
					)
				layer_graph_node_main_inst_dict[
					new_graph_node_main_instr.instruction_key
					] = new_graph_node_main_instr
	if ! curent_layer:
		#push_warning("curent_layer Is Null")
		return
	LoadLayerUI(curent_layer)
	
const IsConstLayerTrue : bool = true
const OpenConnector : bool = true

## СОЗДАЕТ И ЗАГРУЖАЕТ ФИНАЛЬНыЙ СПИСОК И ПОДГРУЖАЕТ ДАННЫЕ ИСХОДЯ ИЗ НАСТРОЕК СЦЕНЫ 
## И УЖЕ ОТДАЕТ В РЕДАКТОР
var curent_layer : EditorLayer
func LoadLayerUI( layer : EditorLayer ) -> void:
	print("_Load Ui Layer For: ",layer.resource_name)
	
	if ! add_node_popup_manager:
		push_error("graph_manager Is Null")
		return
	
	id_to_graph_node_main_instr.clear()
	add_node_popup_manager.Clear()
	
	var instruction_key_ar : Array[String] = layer.GetUiGraphNodeInstrKeys()

	for ui_layer_key in layer.GetUiMakeLayer():
		instruction_key_ar.append_array(
			FromLayerDataKeyToInstructionKeyAr(ui_layer_key)
			)
	
	for instruction_key in instruction_key_ar:
		
		var ui_node_main : GraphNodeMainInstr = FromInstructionKeyToGraphNodeMainInstr(
			instruction_key
			)
		if ui_node_main is GraphNodeMainInstr:
			var ui_popup_id : int = add_node_popup_manager.AddNode(
				UiEditorConst.UiAddNodeCategory[ui_node_main.ui_category],
				ui_node_main.GetTitle()
				)
			if ui_popup_id == GraphManager.EmptyId:
				push_error("New id Is Empty")
				return
				
			id_to_graph_node_main_instr[ui_popup_id] = ui_node_main
	
	curent_layer = layer

func FromLayerDataKeyToInstructionKeyAr( layer_data_key : String ) -> Array[String]:
	var instr_key_ar : Array[String]
	
	for instr in layer_graph_node_main_inst_dict.keys():
		if instr is String:
			if instr.begins_with(layer_data_key):
				instr_key_ar.append(instr)
	
	return instr_key_ar

const MaxInstrSize : int = 1
func FromInstructionKeyToGraphNodeMainInstr( instruction_key : String) -> GraphNodeMainInstr:
	var instr_ar : Array[GraphNodeMainInstr]
	if layer_graph_node_main_inst_dict.has(instruction_key):
		instr_ar.append(layer_graph_node_main_inst_dict[instruction_key])
	if graph_node_main_inst_dict.has(instruction_key):
		instr_ar.append(graph_node_main_inst_dict[instruction_key])
	
	if instr_ar.size() > MaxInstrSize:
		push_error("instr_ar More ",MaxInstrSize)
	elif instr_ar.is_empty():
		if graph_node_main_inst_dict.has(empty_instruction_key):
			push_warning("instruction_key Is Null")
			return graph_node_main_inst_dict[empty_instruction_key]
	
	return instr_ar.pop_back()

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
