extends Resource
class_name GraphNodeLayerInstr

@export var title : UiEditorConst.EnumGraphNodeLayer

@export var body_node : EditorConst.BodyNode
@export var body_data_key : EditorConst.DataKey

@export var is_left : bool = false
@export var left_connector_type : EditorConst.ConnectorType

@export var is_right : bool = false
@export var right_connector_type : EditorConst.ConnectorType
