extends EditorSystem
class_name ExportDataSystem 

@export_group("System")
@export var main_editor : MainEditor
@export var scene_manager : SceneManager
@export var ui_node_manager : UiNodeManager

const F_Export : String = "Export"

var layer_ar : Array # EditorLayer
func StartBake() -> void:
	if ! main_editor:
		push_error("Export ERROR")
		return 
	
	layer_ar = main_editor.GetArEditorlayers()
		

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
	
	var import_data_container : Array[DataContainer] = MakeImportData(start_link_ar)


func MakeImportData(start_link_ar : Array[ExportLink]) -> Array[DataContainer]: # Пока вопрос о выводе
	
	var data_container_ar : Array[DataContainer]
	
	if ! main_editor:
		push_error("Export ERROR")
		return data_container_ar

	var curent_save = main_editor.GetActualEditorSave()
	if ! curent_save:
		push_error("curent_save Is Null")
		return data_container_ar
	
	var free_link : Array[ExportLink] = start_link_ar
	var occupied_link : Array[ExportLink]
	while ! free_link.is_empty():
		
		var curent_link = free_link.pop_back()
		occupied_link.append(curent_link)
		
		var curent_baker : BakerRule = FromDataKeyToBakerRule(curent_link.data_key)
		var obj : LeSceneFile = curent_save.GetObjectFromId(curent_link.data_key,curent_link.id_obj)
		if ! obj:
			push_error("obj Is Null: ",curent_link.data_key," ",curent_link.id_obj)
			return data_container_ar
		
		var full_link := obj.full_link
		var start_graph_node_data : GraphNodeData
		
		for graph_node_data in full_link.keys():
			if graph_node_data is GraphNodeData:
				if graph_node_data.instruction_key == curent_baker.GetStartInstructionKey():
					if graph_node_data.GetData(EditorConst.DataKey.FirstData) == curent_link.link_name:
						start_graph_node_data = graph_node_data
						break
		
		var new_bake_data_container = BakeFullLink(
			start_graph_node_data, full_link, curent_baker 
			)
		
		for link in new_bake_data_container.new_link_ar:
			if IsLinkUnic(free_link, link) and IsLinkUnic(occupied_link, link):
				## А ТАКЖЕ ПРОВЕРКА ПО UI
				free_link.append(link) 
		
		print(new_bake_data_container.data_container.step_ar)
		data_container_ar.append(new_bake_data_container.data_container)
		
	return data_container_ar

func IsLinkUnic( link_ar : Array[ExportLink], unic_link : ExportLink ) -> bool:
	for link in link_ar:
		if link.data_key == unic_link.data_key:
			if link.id_obj == unic_link.id_obj:
				if link.link_name == unic_link.link_name:
					return false
	return true

func BakeFullLink( 
		start_graph_data : GraphNodeData, full_link : Dictionary, baker_rule : BakerRule
		) -> BakeDataContainer:
	
	var data_container := DataContainer.new()
	
	var free_graph_node_data : Array[GraphNodeData]
	free_graph_node_data.append(start_graph_data)
	
	var occupied_graph_node_data : Array[GraphNodeData]
	
	while ! free_graph_node_data.is_empty():
		
		var curent_graph_node_data = free_graph_node_data.pop_back()
		occupied_graph_node_data.append(curent_graph_node_data)
		
		print(full_link[curent_graph_node_data])
		
	
	var bake_data_container := BakeDataContainer.new()
	bake_data_container.data_container = data_container
	
	return bake_data_container

func FromDataKeyToBakerRule( data_key : String ) -> BakerRule:
	for layer in layer_ar:
		if layer is EditorLayer:
			if layer.resource_name == data_key:
				return layer.baker_rule
	push_error("BakerRule Is Null")
	return


		#print(curent_link.link_name," ",start_graph_node_data)
		
		#if all_graph.has(curent_link.data_key):
			#graph = all_graph[curent_link.data_key]
		#else:
			#graph = GetActualGraphs( curent_link )
			#all_graph[curent_link.data_key] = graph

#func GetActualGraphs( export_link : ExportLink ) -> Dictionary:
	#
	#var graph : Dictionary
	#
	#if ! main_editor:
		#push_error("Get Graph ERROR")
		#return graph
	#
	#var editor_data = main_editor.GetActualEditorSave()
	#if ! editor_data:
		#push_error("Get Graph ERROR")
		#return graph
	#
	#var file = editor_data.GetObjectFromId( export_link.data_key, export_link.id_obj )
	#if file is LeSceneFile:
		 #
		#for full_connector in file.full_link:
			#pass
	#
	#return graph
	#
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
