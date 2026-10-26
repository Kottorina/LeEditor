extends Resource
class_name GraphNodeLayerInstr

var is_custom_title : bool = false
var custom_title : String 

@export var title : UiEditorConst.EnumGraphNodeLayer

@export var body_node : EditorConst.BodyNode
@export var body_data_key : EditorConst.DataKey

@export var is_left : bool = false
@export var left_connector_type : EditorConst.ConnectorType = EditorConst.ConnectorType.Tool

@export var is_right : bool = false
@export var right_connector_type : EditorConst.ConnectorType = EditorConst.ConnectorType.Tool

@export var preset_data : UiEditorConst.EnumPresetData = UiEditorConst.EnumPresetData.Nothing
