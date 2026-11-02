extends GraphEdit
class_name GraphManager

@export_group("Managers")
@export var main_editor : MainEditor
@export var ui_node_manager : UiNodeManager
@export var ui_node_maker : UiNodeMaker

func GetSceneUi() -> SceneUi:
	var new_ui := SceneUi.new()
	
	new_ui.zoom = zoom
	new_ui.scroll_offset = scroll_offset
	
	return new_ui
func SetSceneUi( scene_ui : SceneUi ) -> void:
	if scene_ui:
		zoom = scene_ui.zoom
		scroll_offset = scene_ui.scroll_offset
	else:
		push_warning("scene_ui Is Empty")

var main_free_popup : PopupMenu
var main_popup_id_to_calable_dict : Dictionary

var add_node_popup : PopupMenu


const EmptyId : int = -1
var free_ind : int = 0
func GetFreeId() -> int:
	free_ind += 1
	return free_ind

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
	
	free_ind = EmptyId
	
	main_free_popup = PopupMenu.new()

	add_node_popup = PopupMenu.new()
	
	main_free_popup.add_submenu_node_item(
		UiEditorConst.AddNode,add_node_popup,GetFreeId()
		)
	# /
	var calable_copy := Callable(self,"CopySelectedNode")
	var id_0 = GetFreeId()
	main_free_popup.add_item(UiEditorConst.CopyNode,id_0)
	
	main_popup_id_to_calable_dict[id_0] = calable_copy
	# /
	var calable_del := Callable(self,"DelSelectedNode")
	var id_1 = GetFreeId()
	main_free_popup.add_item(UiEditorConst.DelNode,id_1)
	
	main_popup_id_to_calable_dict[id_1] = calable_del
	# /
	
	add_child(main_free_popup)
	if ! main_free_popup.id_pressed.is_connected(MainPopupPressedId):
		main_free_popup.id_pressed.connect(MainPopupPressedId)
	
	if ! connection_request.is_connected(OnConnectionRequest):
		connection_request.connect(OnConnectionRequest)

func GetAddNodePopup() -> PopupMenu:
	if ! add_node_popup:
		push_error("add_node_popup Is Null")
		return
	return add_node_popup

func MainPopupPressedId( id : int ) -> void:
	if main_popup_id_to_calable_dict.has(id):
		main_popup_id_to_calable_dict[id].call()

func GetAllSelectedNode() -> Array[EditorGraphNode]:
	var selected_node_ar : Array[EditorGraphNode]
	for node in GetAllEditorGraphNode():
		if node.selected == true:
			selected_node_ar.append(node)
	return selected_node_ar

const CopyPositionOffset := Vector2(-50,-50)
const SelectedNewNode : bool = true
const SelectedOldNode : bool = false
func CopySelectedNode() -> void:
	if ! ui_node_maker:
		push_error("ui_node_maker Is Null")
		return
	
	for node in GetAllSelectedNode():
		node.selected = SelectedOldNode
		
		var instr_key : String = node.instruction_key
		var new_position : Vector2 = node.position_offset + CopyPositionOffset
		var graph_node_instr = ui_node_manager.FromInstructionKeyToGraphNodeMainInstr(
			instr_key
			)
		var new_id : int = ui_node_maker.MakeNewGraphNode(graph_node_instr,new_position)
		var editor_graph_node = ui_node_maker.FromIdToEditorGraphNode(new_id)
		
		editor_graph_node.selected = SelectedNewNode

func DelSelectedNode() -> void:
	for node in GetAllSelectedNode():
		for connection in get_connection_list_from_node(node.name):
			if connection[FromNode] == node.name:
				var dir_node : EditorGraphNode = get_node( NodePath(connection[ToNode]) ) 
				if dir_node.instruction_key == direction_instruction_key:
					dir_node.queue_free()
			elif connection[ToNode] == node.name:
				var dir_node : EditorGraphNode = get_node( NodePath(connection[FromNode]) ) 
				if dir_node.instruction_key == direction_instruction_key:
					dir_node.queue_free()
		node.queue_free()

const PortNull : int = 0
const FromNode : String = "from_node"
const FromPort : String = "from_port"
const ToNode : String = "to_node"
const ToPort : String = "to_port"
func OnConnectionRequest(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	
	var is_connected_flag : bool = false
	var connection_dir_node_name : StringName 
	
	for connection in get_connection_list_from_node(from_node):
		if get_node( NodePath(connection[ToNode]) ).instruction_key == direction_instruction_key:
			if connection[FromPort] == from_port:
				for connection_dir in get_connection_list_from_node(connection[ToNode]):
					if connection_dir[ToNode] == to_node:
						if connection_dir[ToPort] == to_port:
							is_connected_flag = true
							connection_dir_node_name = connection[ToNode]
							break
	
	if is_connected_flag == true:
		var dir_node = get_node( NodePath(connection_dir_node_name) )
		if dir_node is EditorGraphNode:
			dir_node.queue_free()
	else:
		if get_node( NodePath(from_node)) is EditorGraphNode and get_node( NodePath(to_node))is EditorGraphNode :
			if get_node( NodePath(from_node)).instruction_key == direction_instruction_key and get_node( NodePath(to_node)).instruction_key == direction_instruction_key :
				return
			
			var from : EditorGraphNode = get_node( NodePath(from_node))
			var from_pos: Vector2 = from.position_offset + from.get_output_port_position(from_port)
			
			var to : EditorGraphNode = get_node( NodePath(to_node))
			var to_pos: Vector2 = to.position_offset + to.get_input_port_position(to_port)
			
			var central_pos : Vector2 = (to_pos + from_pos) / 2
			
			var graph_node_main_instr = ui_node_manager.FromInstructionKeyToGraphNodeMainInstr(
			 	direction_instruction_key
				)
			var cental_id : int = ui_node_maker.MakeNewGraphNode(graph_node_main_instr,central_pos)
			var direction_node = ui_node_maker.FromIdToEditorGraphNode(cental_id)
			
			connect_node(from_node, from_port, direction_node.name, PortNull)
			connect_node(direction_node.name, PortNull, to_node, to_port)
#			connect_node(from_node, from_port, to_node, to_port)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			main_free_popup.position = Vector2i(get_global_mouse_position())
			main_free_popup.popup()
			accept_event()

func ClearField() -> void:
	for node in GetAllEditorGraphNode():
		node.queue_free()

func GetAllEditorGraphNode() -> Array[EditorGraphNode]:
	var editor_graph_node_ar : Array[EditorGraphNode]
	for node in get_children():
		if node is EditorGraphNode:
			editor_graph_node_ar.append(node)
	return editor_graph_node_ar

func GetGraphCoordMouse() -> Vector2:
	var popup_screen_pos: Vector2 = main_free_popup.get_screen_transform().origin
	
	var graph_local_pos: Vector2 = get_global_transform_with_canvas().affine_inverse() * popup_screen_pos
	var graph_coord: Vector2 = (graph_local_pos + scroll_offset) / zoom

	return graph_coord
