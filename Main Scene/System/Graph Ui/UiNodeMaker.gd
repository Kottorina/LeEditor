extends EditorSystem
class_name UiNodeMaker

@export var graph_manager : GraphManager

var id_to_editor_graph_node_dict : Dictionary

func MakeNewGraphNode(
	ui_node_main_instr : GraphNodeMainInstr, coord : Vector2 = Vector2.ZERO,
	graph_node_data : GraphNodeData = null
	) -> int:
	
	if ! graph_manager:
		push_error("graph_manager Is Null")
		return NullId
	
	var new_graph_node := EditorGraphNode.new()
	new_graph_node.title = UiEditorConst.UiGraphNodeMain[ui_node_main_instr.title]
	new_graph_node.position_offset = coord
	
	new_graph_node.type = ui_node_main_instr.type
	
	new_graph_node.instruction_key = ui_node_main_instr.instruction_key
	
	var port_ind = 0
	for layer : GraphNodeLayerInstr in ui_node_main_instr.layer_instr_ar:
		
		var child_node : Control ## КОНТЕЙНЕР
		var active_node : Control ## НОД ДЛЯ ВВОДА ДАННЫХ
		
		match layer.body_node:
			EditorConst.BodyNode.Label_:
				active_node = Label.new()
				active_node.horizontal_alignment = GraphNodeConstants.LABEL_HORIZONTAL_ALIGNMENT
				active_node.text = UiEditorConst.UiGraphNodeLayer[layer.title]
				new_graph_node.add_child(active_node)
			
			EditorConst.BodyNode.SpinBox_:
				child_node = HBoxContainer.new()
				
				new_graph_node.add_child(child_node)
				var label = Label.new()
				label.text = UiEditorConst.UiGraphNodeLayer[layer.title]
				
				active_node = SpinBox.new()
				active_node.step = GraphNodeConstants.SPINBOX_BASE_STEP
				
				child_node.add_child(label)
				child_node.add_child(active_node)
				
				if graph_node_data != null:
					var data = graph_node_data.GetData(layer.body_data_key)
					if data != null:
						active_node.value = data
					else:
						push_warning("Data Is Null")
			EditorConst.BodyNode.TextEdit_:
				child_node = HBoxContainer.new()
				
				var label = Label.new()
				label.text = UiEditorConst.UiGraphNodeLayer[layer.title]
				
				active_node = TextEdit.new()
				active_node.scroll_fit_content_height = GraphNodeConstants.TEXT_FIT_CONTENT_HEIGHT
				active_node.scroll_fit_content_width = GraphNodeConstants.TEXT_FIT_CONTENT_WIDTH
				active_node.custom_minimum_size.x = GraphNodeConstants.TEXT_MINIMUM_SIZE_X
				
				new_graph_node.add_child(child_node)
				child_node.add_child(label)
				child_node.add_child(active_node)
				if graph_node_data != null:
					var data = graph_node_data.GetData(layer.body_data_key)
					if data != null:
						active_node.text = data
					else:
						push_warning("Data Is Null")
			EditorConst.BodyNode.CheckBox_:
				child_node = HBoxContainer.new()
				
				var label = Label.new()
				label.text = UiEditorConst.UiGraphNodeLayer[layer.title]
				
				active_node = CheckBox.new()
				
				new_graph_node.add_child(child_node)
				child_node.add_child(label)
				child_node.add_child(active_node)
				if graph_node_data != null:
					var data = graph_node_data.GetData(layer.body_data_key)
					if data != null:
						active_node.button_pressed = data
					else:
						push_warning("Data Is Null")
			
		new_graph_node.set_slot(
			port_ind,
			layer.is_left,
			EditorConst.ConnectorValue[layer.left_connector_type],
			EditorConst.ConnectorColor[layer.left_connector_type],
			layer.is_right,
			EditorConst.ConnectorValue[layer.right_connector_type],
			EditorConst.ConnectorColor[layer.right_connector_type],
			)
		
		if layer.body_data_key != EditorConst.DataKey.Nothing:
			var new_metadata := GraphNodeMetadata.new()
			new_metadata.port_num
			new_metadata.data_key = layer.body_data_key
			new_metadata.ui_node = active_node
			new_metadata.ui_node_type = layer.body_node
			
			new_graph_node.metadata_ar.append(new_metadata)
		
		port_ind += 1
	
	graph_manager.add_child(new_graph_node)
	
	var id = GetFreeId()
	id_to_editor_graph_node_dict[id] = new_graph_node
	return id

func FromIdToEditorGraphNode(id : int) -> EditorGraphNode:
	if id_to_editor_graph_node_dict.has(id):
		return id_to_editor_graph_node_dict[id]
	return 

func MakeConnection(from_id, from_port, to_id, to_port) -> void:
	pass
