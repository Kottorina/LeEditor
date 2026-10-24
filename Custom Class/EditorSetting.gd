extends Resource
class_name EditorSetting

## НАСТРОЙКИ ДЛЯ САМОГО РЕДАКТОРА, ПУТИ И СОСТОЯНИЯ ОБЬЕКТОВ

@export var is_auto_export : bool
@export var setting_panel_visible : bool

@export var path_to_editor_data : String
@export var curent_layer : int
@export var curent_scene : int

const Layer : String = "curent_layer"
const Scene : String = "curent_scene"
