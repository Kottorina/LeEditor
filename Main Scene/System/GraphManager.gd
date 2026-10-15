extends GraphEdit
class_name GraphManager

func GetSceneUi() -> SceneUi:
	var new_ui := SceneUi.new()
	
	new_ui.zoom = zoom
	new_ui.scroll_offset = scroll_offset
	
	return new_ui

func SetSceneUi( scene_ui : SceneUi ) -> void:
	if scene_ui:
		zoom = scene_ui.zoom
		print(scene_ui.scroll_offset)
		scroll_offset = scene_ui.scroll_offset
	else:
		push_warning("scene_ui Is Empty")
	print(scroll_offset)

var main_free_popup : PopupMenu
var add_node_popup : PopupMenu
func StartBake() -> void:
	main_free_popup = PopupMenu.new()
	add_node_popup = PopupMenu.new()
	
	main_free_popup.add_submenu_node_item(UiEditorConst.AddNode,add_node_popup)
	
	add_child(main_free_popup)
	#Здесь подключения что бы снимать данные и тд

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		print("D")
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			main_free_popup.position = Vector2i(get_global_mouse_position())
			main_free_popup.popup()
			accept_event()


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
#func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	#if is_node_connected(from_node, from_port, to_node, to_port):
		#disconnect_node(from_node, from_port, to_node, to_port)
	#else:
		#connect_node(from_node, from_port, to_node, to_port)
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
