extends EditorSystem
class_name ExportDataManager

@export var main_editor : MainEditor
@export var scene_manager : SceneManager
@export var ui_node_manager : UiNodeManager

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
