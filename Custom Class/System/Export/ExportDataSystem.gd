extends EditorSystem
class_name ExportDataSystem 

@export_group("System")
@export var main_editor : MainEditor
@export var scene_manager : SceneManager
@export var ui_node_manager : UiNodeManager

const F_Export : String = "Export"

func Export() -> void:
	if ! scene_manager or ! main_editor:
		push_error("Export ERROR")
		return 
	
	print("_Export Curent Scene")
	
	var start_link_ar : Array[ExportLink]
	
	if main_editor.GetSettingValue(EditorSetting.name_is_quick_export):
		start_link_ar.append_array(scene_manager.GetCurentExportLink())
	else:
		pass## Логика Для UI
	
	var import_data = MakeImportData(start_link_ar)


func MakeImportData(start_link_ar : Array[ExportLink]): # Пока вопрос о выводе
	var all_graph : Dictionary
	
	var processing_link : Array[ExportLink] = start_link_ar
	var processed_link : Array[ExportLink]
	while ! processing_link.is_empty():
		
		var curent_link = processing_link.pop_back()
		processed_link.append(curent_link)
		
		var graph : Dictionary
		if all_graph.has(curent_link.data_key):
			graph = all_graph[curent_link.data_key]
		else:
			graph = GetActualGraphs( curent_link )
			all_graph[curent_link.data_key] = graph
	
	

func GetActualGraphs( export_link : ExportLink ) -> Dictionary:
	
	var graph : Dictionary
	
	if ! main_editor:
		push_error("Get Graph ERROR")
		return graph
	
	var editor_data = main_editor.GetActualEditorSave()
	if ! editor_data:
		push_error("Get Graph ERROR")
		return graph
	
	var file = editor_data.GetObjectFromId( export_link.data_key, export_link.id_obj )
	if file is LeSceneFile:
		 
		for full_connector in file.full_connection_line_ar:
			pass
	
	return graph
	
	#
	
	## СМОТРИ НА ТИП НОДА ПРИ ЗАПИСИ, ЧАСТЬ ЭТО DIRECTION
	
	#var start_gener_nodes : Array[EditorGraphNode]
	#var all_editor_geaph_node = graph_manager.GetAllEditorGraphNode()
	#for graph_node in all_editor_geaph_node:
		#if graph_node.instruction_key == baker.GetInstructionKey():
			#start_gener_nodes.append(graph_node)
	#
	#for start_node in start_gener_nodes:
		#
		#var free_nodes_ar : Array[EditorGraphNode]
		#free_nodes_ar.append(start_node)
		#
		#while ! free_nodes_ar.is_empty():
			#
			#var curent_node = free_nodes_ar.pop_back()
			#
			#var connections = graph_manager.get_connection_list_from_node(
				#curent_node.name
				#)
			#for connect_line in connections:
				#
	#return {}
