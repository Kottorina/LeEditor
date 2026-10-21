extends Node
class_name SceneLoader

@export_group("Managers")

@export var graph_manager : GraphManager
@export var ui_node_maker : UiNodeMaker
@export var ui_node_manager : UiNodeManager

func LoadScene( scene : LeSceneFile ) -> void:
	print("_Load Scene: ",scene.scene_name)
	
	if ! graph_manager or ! ui_node_maker or ! ui_node_manager:  
		push_error("Load Error")
		return
	
	graph_manager.ClearField()
	
	var graph_data_to_id_dict : Dictionary
	for node_data in scene.graph_node_data_ar:
		var id = ui_node_maker.MakeNewGraphNode(
			ui_node_manager.FromInstructionKeyToGraphNodeMainInstr(node_data.instruction_key),
			node_data.position_node,
			node_data,
			)
		graph_data_to_id_dict[node_data] = id
	
	for connection_line in scene.connection_line_ar:
		ui_node_maker.MakeConnection(
			graph_data_to_id_dict[connection_line.from_data],
			connection_line.from_port,
			graph_data_to_id_dict[connection_line.to_data],
			connection_line.to_port
		)
	
	graph_manager.SetSceneUi(scene.ui_scene) ## В конце из за особенностей загрузки GraphManager
