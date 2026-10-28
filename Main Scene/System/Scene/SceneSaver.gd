extends Node
class_name SceneSaver

@export_group("Managers")

@export var ui_node_manager : UiNodeManager
@export var graph_manager : GraphManager
@export var main_editor : MainEditor

const FromNode : String = "from_node"
const FromPort : String = "from_port"
const ToNode : String = "to_node"
const ToPort : String = "to_port"
const KeepAlive : String = "keep_alive"

const KeppAliveTrue : bool = true

var direction_instruction_key : String
func StartBake() -> void:
	
	if ! main_editor:
		push_error("main_editor Is Null")
		return
	var direction_instr : GraphNodeMainInstr = main_editor.direction_graph_node_instr
	if ! direction_instr:
		push_error("empty_instr Is Null")
		return
	direction_instruction_key = direction_instr.resource_path.get_file().get_basename()
	

func GetActualScene() -> LeSceneFile:
	var scene := LeSceneFile.new() 
	
	if ! graph_manager or ! ui_node_manager:
		push_error("GetActualScene Is Null")
		return
	
	var all_editor_geaph_node = graph_manager.GetAllEditorGraphNode()
	var from_node_name_to_node_data_dict : Dictionary
	
	## ЗАПОЛНЯЕМ ui_scene
	scene.ui_scene = graph_manager.GetSceneUi()
	
	## ЗАПОЛНЯЕМ from_node_name_to_node_data_dict И graph_node_data_ar
	for graph_node in all_editor_geaph_node:
		var node_data = FromGraphNodeToGraphNodeData(graph_node)
		from_node_name_to_node_data_dict[graph_node.name] = node_data
		
		scene.graph_node_data_ar.append(node_data)
	
	## ЗАПОЛНЯЕМ base_connection_line_ar
	for connect_line in graph_manager.connections:
		if connect_line[KeepAlive] == KeppAliveTrue:
			continue
		var base_connection_line := BaseConnectionLine.new()
		
		base_connection_line.from_data = from_node_name_to_node_data_dict[connect_line[FromNode]]
		base_connection_line.from_port = connect_line[FromPort]
		base_connection_line.to_data = from_node_name_to_node_data_dict[connect_line[ToNode]]
		base_connection_line.to_port = connect_line[ToPort]
		
		scene.base_connection_line_ar.append(base_connection_line)
	
	## ЗАПОЛНЯЕМ full_connection_line_ar
	for graph_node in all_editor_geaph_node:
		
		if graph_node.instruction_key == direction_instruction_key: ## Это Служебный Нод
			continue
		
		for connection in graph_manager.get_connection_list_from_node(graph_node.name):
			
			var full_connection_line := FullConnectionLine.new()
			
			var from_data : GraphNodeData
			var to_data : GraphNodeData
			var from_port : int
			var from_port_is_left : bool
			var to_port : int
			var to_port_is_left : bool
			
			var dir_direction : EditorConst.Direction
			
			if connection[FromNode] == graph_node.name:
				
				from_data = from_node_name_to_node_data_dict[connection[FromNode]]
				from_port = connection[FromPort]
				from_port_is_left = false
				
				var dir_node = graph_manager.get_node( NodePath(connection[ToNode]) )
				for dir_connection in graph_manager.get_connection_list_from_node(dir_node.name):
					if dir_connection[FromNode] == dir_node.name:
						
						to_data = from_node_name_to_node_data_dict[dir_connection[ToNode]]
						to_port = dir_connection[ToPort]
						to_port_is_left = true
						
						var dir_data = from_node_name_to_node_data_dict[dir_node.name]
						if dir_data:
							var dir_value : int = dir_data.GetData(EditorConst.ui_graph_node_direction_data_key)
							if dir_value:
								match dir_value:
									0:
										dir_direction = EditorConst.Direction.omnidir
									1:
										dir_direction = EditorConst.Direction.forward
									2:
										dir_direction = EditorConst.Direction.backward
			
			elif connection[ToNode] == graph_node.name:
				
				from_data = from_node_name_to_node_data_dict[connection[ToNode]]
				from_port = connection[ToPort]
				from_port_is_left = true
				
				var dir_node = graph_manager.get_node( NodePath(connection[FromNode]) )
				for dir_connection in graph_manager.get_connection_list_from_node(dir_node.name):
					if dir_connection[ToNode] == dir_node.name:
						
						to_data = from_node_name_to_node_data_dict[dir_connection[FromNode]]
						to_port = dir_connection[FromPort]
						to_port_is_left = false

						var dir_data = from_node_name_to_node_data_dict[dir_node.name]
						if dir_data:
							var dir_value : int = dir_data.GetData(EditorConst.ui_graph_node_direction_data_key)
							if dir_value:
								match dir_value:
									0:
										dir_direction = EditorConst.Direction.omnidir
									1:
										dir_direction = EditorConst.Direction.backward
									2:
										dir_direction = EditorConst.Direction.forward
			
			else:
				push_error("full_connection_line_ar Make ERROR")
				return
			
			if ! from_data or ! to_data:
				push_warning("Dir Without Node")
				continue
			
			var from_data_key : EditorConst.DataKey = GetDataKeyFromInstr(
				from_data.instruction_key,from_port_is_left,from_port
				)
			var to_data_key : EditorConst.DataKey = GetDataKeyFromInstr(
				to_data.instruction_key,to_port_is_left,to_port
				)
			
			#if dir_node.instruction_key == direction_instruction_key:
				
			full_connection_line.from_data = from_data
			full_connection_line.to_data = to_data
			full_connection_line.from_key = from_data_key
			full_connection_line.to_key = to_data_key
			full_connection_line.direction = dir_direction
			scene.full_connection_line_ar.append(full_connection_line)
	
	return scene

func GetDataKeyFromInstr(instr_key : String, is_left : bool, port_ind : int) -> EditorConst.DataKey:
	var ui_graph_node_instr = ui_node_manager.FromInstructionKeyToGraphNodeMainInstr(
		instr_key
		)
	if ! ui_graph_node_instr:
		push_error("from_ui_graph_node_instr Is Null")
		return EditorConst.DataKey.Nothing
	#print(": ",port_ind)
	#print(EditorConst.GraphNodeType.keys()[ui_graph_node_instr.type])
	var curent_port_ind : int = 0
	for layer_instr : GraphNodeLayerInstr in ui_graph_node_instr.layer_instr_ar:
		#print(layer_instr.body_data_key)
		
		if is_left == true:
			
			if layer_instr.is_left == true:
				if curent_port_ind == port_ind:
					return layer_instr.body_data_key
				curent_port_ind += 1
		
		if is_left == false:
		
			if layer_instr.is_right == true:
				if curent_port_ind == port_ind:
					return layer_instr.body_data_key
				curent_port_ind += 1
	
	push_error("GetDataKeyFromInstr Is ERROR")
	return EditorConst.DataKey.Nothing

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
		EditorConst.BodyNode.OptionButton_:
			return ui_node.selected
			
	return

func GetActulaSceneMetadata() -> LeScenesMetadataFile:
	var scene_metadata := LeScenesMetadataFile.new() 
	
	return scene_metadata

func GetValidDataNameArray( 
	baker : BakerRule, 
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
