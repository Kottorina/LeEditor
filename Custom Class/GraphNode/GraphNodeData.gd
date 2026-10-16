extends Resource
## Для Данных Нодов (Не Соединений)
class_name GraphNodeData

@export var instruction_key : String 
@export var position_node : Vector2i

@export var data : Dictionary
func GetInsideData( data_key : EditorConst.DataKey) -> Variant:
	if data.has(data_key):
		return data[data_key]
	return null
func SetInsideData( data_key : EditorConst.DataKey, value : Variant ) -> void:
	data[data_key] = value
