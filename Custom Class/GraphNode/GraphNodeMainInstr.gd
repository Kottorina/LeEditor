extends Resource
class_name GraphNodeMainInstr

var instruction_key : String

@export var title : UiEditorConst.EnumGraphNodeMain

@export var type : EditorConst.GraphNodeType

@export var ui_category : UiEditorConst.EnumAddNodeCategory ## КАТЕГОРИЯ ПРИ ЗАПЕКАНИИ UI

@export var layer_instr_ar : Array[GraphNodeLayerInstr]
