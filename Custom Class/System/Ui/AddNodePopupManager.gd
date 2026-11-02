extends EditorSystem
class_name AddNodePopupManager

@export_group("Managers")
@export var graph_manager : GraphManager
@export var ui_node_manager : UiNodeManager

func StartBake() -> void:
	var add_node_popup = GetAddNodePopup()
	if ! add_node_popup:
		push_error("add_node_popup Is Null")
		return
	
	if ! add_node_popup.id_pressed.is_connected(AddNodePressedId):
		add_node_popup.id_pressed.connect(AddNodePressedId)

func GetAddNodePopup() -> PopupMenu:
	if ! graph_manager:
		push_error("graph_manager Is Null")
		return
	
	return graph_manager.GetAddNodePopup()

var add_node_id_to_node_dict : Dictionary
func Clear() -> void:
	
	var add_node_popup = GetAddNodePopup()
	if ! add_node_popup:
		push_error("add_node_popup Is Null")
		return
	
	if add_node_popup:
		add_node_popup.clear()
		add_node_id_to_node_dict.clear()
		return
	push_error("add_node_popup Is Null")

var free_add_node_id : int = 0
func AddNode( ui_category : String, ui_node_name : String ) -> int:
	
	var add_node_popup = GetAddNodePopup()
	if ! add_node_popup:
		push_error("add_node_popup Is Null")
		return NullId
	
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

#func RemoveNode()

func AddNodePressedId( id : int ) -> void:
	
	if ! ui_node_manager or ! graph_manager:
		push_error("ui_node_manager Is Null")
		return
	
	ui_node_manager.FromIdAndCoordMakeNewUiNode(id,graph_manager.GetGraphCoordMouse())
