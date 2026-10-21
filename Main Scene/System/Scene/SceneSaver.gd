extends Node
class_name SceneSaver

@export_group("Managers")

@export var graph_manager : GraphManager

func GetActualScene() -> LeSceneFile:
	
	var scene := LeSceneFile.new() 
	
	if ! graph_manager:
		push_error("graph_manager Is Null")
		return
	
	scene.ui_scene = graph_manager.GetSceneUi()
	
	var all_editor_geaph_node = graph_manager.GetAllEditorGraphNode()
	
	var from_node_to_node_data_dict : Dictionary
	for graph_node in all_editor_geaph_node:
		var node_data = FromGraphNodeToGraphNodeData(graph_node)
		from_node_to_node_data_dict[graph_node.name] = node_data
		
		scene.graph_node_data_ar.append(node_data)
	
	var occupied_node_ar : Array = []
	for graph_node in all_editor_geaph_node:
		
		var connections = graph_manager.get_connection_list_from_node(graph_node.name)
		occupied_node_ar.append(graph_node.name)
		
		for connect_line in connections:
			
			if graph_node.name == connect_line[FromNode]:
				if ! occupied_node_ar.has(connect_line[ToNode]):
					var from_to_with := ConnectionLine.new()
					
					from_to_with.from_data = from_node_to_node_data_dict[connect_line[FromNode]]
					from_to_with.from_port = connect_line[FromPort]
					from_to_with.to_data = from_node_to_node_data_dict[connect_line[ToNode]]
					from_to_with.to_port = connect_line[ToPort]
					
					scene.connection_line_ar.append(from_to_with)
			elif graph_node.name == connect_line[ToNode]:
				if ! occupied_node_ar.has(connect_line[FromNode]):
					var from_to_with := ConnectionLine.new()
					
					from_to_with.from_data = from_node_to_node_data_dict[connect_line[ToNode]]
					from_to_with.from_port = connect_line[ToPort]
					from_to_with.to_data = from_node_to_node_data_dict[connect_line[FromNode]]
					from_to_with.to_port = connect_line[FromPort]
					
					scene.connection_line_ar.append(from_to_with)
			else:
				push_error("FromToWith ERROR")
	
	return scene

const FromNode : String = "from_node"
const FromPort : String = "from_port"
const ToNode : String = "to_node"
const ToPort : String = "to_port"

func FromGraphNodeToGraphNodeData( graph_node : EditorGraphNode) -> GraphNodeData:
	var new_graph_data := GraphNodeData.new()
		
	new_graph_data.instruction_key = graph_node.instruction_key
	new_graph_data.position_node = graph_node.position_offset
		
	for metadata in graph_node.metadata_ar:
		new_graph_data.SetData(
			metadata.data_key,
			GetValueFromNodeAndType(metadata.ui_node_type,metadata.ui_node)
			)
	
	return new_graph_data

func GetValueFromNodeAndType(node_type : EditorConst.BodyNode, ui_node : Control) -> Variant:
	match node_type:
		EditorConst.BodyNode.Label_:
			return
		EditorConst.BodyNode.SpinBox_:
			return ui_node.value
		EditorConst.BodyNode.TextEdit_:
			return ui_node.text
		EditorConst.BodyNode.CheckBox_:
			return ui_node.button_pressed
	return
