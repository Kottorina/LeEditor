extends EditorSystem
class_name SceneBaker

@export var graph_manager : GraphManager

func GetValidDataNameArray( baker : BakerRule ) -> Array[String]:
	
	if ! graph_manager:
		push_error("Get Valid ERROR")
		return []
	
	var all_editor_geaph_node = graph_manager.GetAllEditorGraphNode()
	for graph_node in all_editor_geaph_node:
		var connections = graph_manager.get_connection_list_from_node(graph_node.name)
		for connect_line in connections:
			print("!")
	
	return []

func GetActualGraphs( baker : BakerRule ) -> Dictionary:
	var graph : Dictionary
	
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
		#
		
	return {}
