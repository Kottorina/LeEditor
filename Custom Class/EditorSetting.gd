extends Resource
class_name EditorSetting

## НАСТРОЙКИ ДЛЯ САМОГО РЕДАКТОРА, ПУТИ И СОСТОЯНИЯ ОБЬЕКТОВ

@export var is_auto_export : bool
@export var setting_panel_visible : bool

@export var path_to_editor_data : String
@export var curent_layer : int
@export var is_quick_export : bool 

const name_is_auto_export : String = "is_auto_export"
const name_is_quick_export : String = "is_quick_export"

const Layer : String = "curent_layer"
