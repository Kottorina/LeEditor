extends Resource
## Для Данных Нодов (Не Соединений). ДЛЯ ЗАПИСИ В СОХРАНЕНИИ
class_name GraphNodeData

@export var instruction_key : String 
@export var position_node : Vector2i

@export var data : Dictionary
func GetData( data_key : EditorConst.DataKey) -> Variant:
	if data.has(data_key):
		return data[data_key]
	return null
func SetData( data_key : EditorConst.DataKey, value : Variant ) -> void:
	data[data_key] = value
