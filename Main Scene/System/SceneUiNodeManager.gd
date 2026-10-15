extends Node
class_name SceneUiNodeManager

@export_group("Managers")

@export var graph_manager : GraphManager

## ПОДГРУЖАЕТ ТАБЛИЦУ С ДИСКА, БАЗОВОЕ И ОПРЕДЕЛЕННОЕ
func StartBake() -> void:
	pass

func MakeUiNodeForScene( scene : LeSceneFile ) -> void:
	pass

## СОЗДАЕТ И ЗАГРУЖАЕТ ФИНАЛЬНыЙ СПИСОК И ПОДГРУЖАЕТ ДАННЫЕ ИСХОДЯ ИЗ НАСТРОЕК СЦЕНЫ 
## И УЖЕ ОТДАЕТ В РЕДАКТОР

 #ИМПОРТИРУЕТ ИМПОРТИРУЕМОЕ, КРОМЕ ОСОБЫХ СЛУЧАЕВ И 
