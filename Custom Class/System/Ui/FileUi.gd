extends MenuButton

@export_group("System")
@export var main_editor : MainEditor
@export var export_data_system : ExportDataSystem

var item_dict : Dictionary
var item_bool_dict : Dictionary

var free_id : int = -1
func GetFreeId() -> int:
	free_id += 1
	return free_id

var main_popup : PopupMenu
func StartBake() -> void:
	if ! main_editor or ! export_data_system:
		push_warning("Main Editor Is Null")
		return
	
	text = UiEditorConst.File
	
	item_dict.clear()
	item_bool_dict.clear()
	
	main_popup = get_popup()
	main_popup.clear()
	
	if ! main_popup.id_pressed.is_connected(ItemSelected):
		main_popup.id_pressed.connect(ItemSelected)
	
	AddNewFuncItem(
		UiEditorConst.Save,
		Callable(main_editor, main_editor.F_SaveCurentData)
		)

	AddNewFuncItem(
		UiEditorConst.Open,
		Callable(main_editor, main_editor.F_NewPath)
		)
	
	AddBoolSetting(
		UiEditorConst.AutoExport,
		EditorSetting.name_is_auto_export
		)
	
	AddBoolSetting(
		UiEditorConst.IsQuickExport,
		EditorSetting.name_is_quick_export
		)
	
	AddNewFuncItem(
		UiEditorConst.Export,
		Callable(export_data_system, export_data_system.F_Export)
		)
	
	
	
func AddNewFuncItem(text_item : String, calable : Callable) -> void:
	var id = GetFreeId()
	main_popup.add_item(text_item,id)
	if ! calable.is_valid():
		push_error("calable Is Not Valid")
		return
	item_dict[id] = calable

func AddBoolSetting(text_item : String, setting_text : String) -> void:
	var id : int = GetFreeId()
	main_popup.add_check_item(text_item,id)
		
	item_dict[id] = func(value: Variant) -> void: 
		main_editor.SetSettingValue(
		setting_text,
		value
		)
	var value_id : bool = main_editor.GetSettingValue(
		setting_text
		)
	main_popup.set_item_checked(id, value_id)
	item_bool_dict[id] = value_id

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
