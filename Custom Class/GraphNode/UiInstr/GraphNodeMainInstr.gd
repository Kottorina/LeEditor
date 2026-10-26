extends Resource
class_name GraphNodeMainInstr

var instruction_key : String

var is_custom_title : bool = false
var custom_title : String 

@export var type : EditorConst.GraphNodeType
@export var ui_category : UiEditorConst.EnumAddNodeCategory ## КАТЕГОРИЯ ПРИ ЗАПЕКАНИИ UI

@export var layer_instr_ar : Array[GraphNodeLayerInstr]

func GetTitle() -> String:
	if is_custom_title:
		return custom_title
	else:
		if UiEditorConst.UiGraphNodeMainTitle.has(type):
			return UiEditorConst.UiGraphNodeMainTitle[type]
	push_error("Title Is Null")
	return UiEditorConst.Empty
