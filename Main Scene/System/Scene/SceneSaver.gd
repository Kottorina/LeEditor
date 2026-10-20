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
	
	for graph_node in graph_manager.GetAllEditorGraphNode():
		var new_graph_data := GraphNodeData.new()
		
		new_graph_data.instruction_key = graph_node.instruction_key
		new_graph_data.position_node = graph_node.position_offset
		
		for metadata in graph_node.metadata_ar:
			new_graph_data.SetData(
				metadata.data_key,
				GetValueFromNodeAndType(metadata.ui_node_type,metadata.ui_node)
				)
		
		scene.graph_node_data_ar.append(new_graph_data)
	
	return scene

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
