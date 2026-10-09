extends MenuButton

@export var main_editor : Node

var item_ar : Array[Callable]

func StartBake() -> void:
	if ! main_editor:
		push_warning("Main Editor Is Null")
		return
	
	text = UiEditorConst.File
	
	item_ar.clear()
	var main_popup = get_popup()
	main_popup.clear()
	
	if ! main_popup.id_pressed.is_connected(ItemSelected):
		main_popup.id_pressed.connect(ItemSelected)
	
	main_popup.add_item(UiEditorConst.Save,item_ar.size())
	item_ar.append(Callable(main_editor, "SaveCurrentEditorData"))
	
	main_popup.add_item(UiEditorConst.Open,item_ar.size())
	item_ar.append(Callable(main_editor, "NewPath"))

func ItemSelected( id : int ) -> void:
	if item_ar.size() < id:
		push_error("id more item_ar.size")
		return
	
	var cal = item_ar[id]
	if cal.is_valid():
		cal.call()
	else:
		push_error("cal Is Not Valid") 
