extends MenuButton

@export var main_editor : MainEditor

var item_dict : Dictionary
var item_bool_dict : Dictionary

var free_id : int = -1
func GetFreeId() -> int:
	free_id += 1
	return free_id

var main_popup : PopupMenu
func StartBake() -> void:
	if ! main_editor:
		push_warning("Main Editor Is Null")
		return
	
	text = UiEditorConst.File
	
	item_dict.clear()
	item_bool_dict.clear()
	
	main_popup = get_popup()
	main_popup.clear()
	
	if ! main_popup.id_pressed.is_connected(ItemSelected):
		main_popup.id_pressed.connect(ItemSelected)
	
	var id_0 : int = GetFreeId()
	main_popup.add_item(UiEditorConst.Save,id_0)
	item_dict[id_0] = Callable(main_editor, "SaveCurrentEditorData")
	
	var id_1 : int = GetFreeId()
	main_popup.add_item(UiEditorConst.Open,id_1)
	item_dict[id_1] = Callable(main_editor, "NewPath")
	
	var id_2 : int = GetFreeId()
	main_popup.add_check_item(UiEditorConst.AutoExport,id_2)
	
	item_dict[id_2] = func(value: Variant) -> void: 
		main_editor.SetSettingValue(
		EditorConst.v_setting_is_auto_export,
		value
		)
	
	var value_id_2 : bool = main_editor.GetSettingValue(
		EditorConst.v_setting_is_auto_export
		)
	main_popup.set_item_checked(id_2, value_id_2)
	item_bool_dict[id_2] = value_id_2

func ItemSelected( id : int ) -> void:
	
	if item_bool_dict.has(id) and item_dict.has(id):
		
		item_bool_dict[id] = ! item_bool_dict[id]
		
		item_dict[id].call(item_bool_dict[id])
		main_popup.set_item_checked(id, item_bool_dict[id])
		return
	
	if item_dict.has(id):
		item_dict[id].call()
		return
	
	#if item_ar.size() < id:
		#push_error("id more item_ar.size")
		#return
	
	#var cal = item_ar[id]
	#if cal.is_valid():
		#cal.call()
	#else:
		#push_error("cal Is Not Valid") 
