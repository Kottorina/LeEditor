extends EditorSystem
class_name SceneBaker

@export var graph_manager : GraphManager

func GetValidDataNameArray( baker : BakerRule, 
	graph_node_data_ar : Array[GraphNodeData] 
	) -> Array[String]:
	
	if ! graph_manager:
		push_error("Get Valid ERROR")
		return []
	
	var valid_data_name_ar : Array[String]
	
	var all_editor_geaph_node = graph_manager.GetAllEditorGraphNode()
	for graph_node_data in graph_node_data_ar:
		if graph_node_data.instruction_key == baker.GetStartInstructionKey():
			valid_data_name_ar.append(
				graph_node_data.GetData(EditorConst.ui_graph_node_start_data_key)
				)
	
	return valid_data_name_ar

#func GetActualGraphs( baker : BakerRule ) -> Dictionary:
	#var graph : Dictionary
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
