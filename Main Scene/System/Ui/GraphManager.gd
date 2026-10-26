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

var add_node_id_to_node_dict : Dictionary
var add_node_popup : PopupMenu

var main_popup_id_to_calable_dict : Dictionary

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
	if ! add_node_popup.id_pressed.is_connected(AddNodePressedId):
		add_node_popup.id_pressed.connect(AddNodePressedId)
	
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

func ClearAddNodePopup() -> void:
	if add_node_popup:
		add_node_popup.clear()
		add_node_id_to_node_dict.clear()
		return
	push_error("add_node_popup Is Null")

var free_add_node_id : int = 0
func ExpandAddNodePopup( ui_category : String, ui_node_name : String ) -> int:
	
	free_add_node_id += 1
	
	for item_ind in add_node_popup.item_count:
		var popup_menu : PopupMenu = add_node_popup.get_item_submenu_node(item_ind)
		if popup_menu:
			if add_node_popup.get_item_text(item_ind) == ui_category:
				popup_menu.add_item(ui_node_name, free_add_node_id)
				return free_add_node_id
	#print("_Make New PopupMenu For: ",ui_category)
	
	var new_popup_menu := PopupMenu.new()
	new_popup_menu.id_pressed.connect(AddNodePressedId)
	add_node_popup.add_submenu_node_item(ui_category,new_popup_menu)

	new_popup_menu.add_item(ui_node_name, free_add_node_id)
	return free_add_node_id

func AddNodePressedId( id : int ) -> void:
	
	if ! ui_node_manager:
		push_error("ui_node_manager Is Null")
		return
	
	var popup_screen_pos: Vector2 = main_free_popup.get_screen_transform().origin
	
	var graph_local_pos: Vector2 = get_global_transform_with_canvas().affine_inverse() * popup_screen_pos
	var graph_coord: Vector2 = (graph_local_pos + scroll_offset) / zoom
	
	ui_node_manager.FromIdAndCoordMakeNewUiNode(id,graph_coord)

#@export var del_but : Button
#@export var copy_but : Button
#
#@export var load_graph : Node
#
#func _ready() -> void:
	#del_but.pressed.connect(on_del_node_pressed)
	#copy_but.pressed.connect(CopyButPressed)
#
#func on_del_node_pressed() -> void:
	#if selected_node != null:
		#selected_node.queue_free()
#
#const CooorCopuPlus := Vector2(-100,-100) 
#
#func CopyButPressed() -> void:
	#if selected_node != null:
		#var big_inst : BigGraphNodeMakeInsts = selected_node.get_meta(GraphNodeConstants.BIG_INSTR_NODE_DATA_NAME).duplicate(true)
		#var new_node = load_graph.MakeNodeFromBigInstr(big_inst)
		#new_node.position_offset = CooorCopuPlus + selected_node.position_offset
		#set_selected(new_node)
		#_on_node_selected(new_node)
#

#
#var selected_node : GraphNode
#@warning_ignore("unused_parameter")
#func _on_node_deselected(node: Node) -> void:
	#selected_node = null
#func _on_node_selected(node: Node) -> void:
	#selected_node = node
#
#func ClearGraphScene() -> void:
	### ОЧИСТИТЬ НАСТРОЙКИ ЕСЛИ ДОБАВЛЮ, ебала я вас всех
	#clear_connections()
	#for child in get_children():
		#if child is GraphNode:
			#child.queue_free()
