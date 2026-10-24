extends Resource
class_name EditorLayer

@export var data_key : String

@export var baker_rule : BakerRule ## Для Запекания

@export var random_bool : bool

## ФЛАГИ ДЛЯ UI, ПРИ ЗАГРУЗКЕ
# ПРЕФИКС "UI_" ОБЯЗАТЕЛЕН
@export_group("Ui")

@export var graph_node_instr_ar : Array[GraphNodeMainInstr]

func GetUiGraphNodeInstrKeys() -> Array[String]:
	var ui_instr_key_ar: Array[String] = []
	for graph_node in graph_node_instr_ar:
		var name : String = graph_node.resource_path.get_file().get_basename()
		ui_instr_key_ar.append(name)
		#if name.begins_with(UiPrefix):
			#if get(name) == true:
				#ui_property_name_ar.append(name.trim_prefix(UiPrefix))
	return ui_instr_key_ar

#@export var ui_all_rnd_fork : bool = false
#@export var ui_custom_big_instr : bool = false ## А ОНО НАМ ВООБЩЕ БЛЯДЬ НАДО В ЭТОМ ВИДЕ?
#@export var ui_connectors_plugs : bool = false
#@export var ui_enter_node : bool = false
## ПОКА ВОПРОС ПО НЕОБХОДИМОСТИ И ОФОРМЛЕНИЮ
#@export var ui_rooms_nodes : bool = false
### МОЖЕТ ВЫЗВАТЬ ОБЬЕКТЫ ИЗ EDITORLAYER В ВИДЕ UI
#@export var ui_editor_layer_nodes : String = ""
#
#@export var ui_crossroad_2 : bool = false
#@export var ui_crossroad_4 : bool = false
#@export var ui_crossroad_6 : bool = false
#
#@export_subgroup("Dialogue")
#@export var ui_dialogue_start : bool = false
#@export var ui_dialogue_node : bool = false
#@export var ui_dialogue_end : bool = false
#
#@export var ui_dialogue_choice_2 : bool = false
#@export var ui_dialogue_choice_3 : bool = false
#@export var ui_dialogue_choice_4 : bool = false
#
#@export var ui_dialogue_con_2 : bool = false
#@export var ui_dialogue_con_4 : bool = false
#@export var ui_dialogue_con_6 : bool = false
#@export var ui_dialogue_setting : bool = false
#
#@export var ui_dialogue_emit_signal : bool = false
#@export var ui_dialogue_await_signal : bool = false
#
#@export var ui_dialogue_next_dialogue : bool = false
#
#@export var ui_dialogue_to_tool : bool = false
##
##@export_subgroup("Audio")
#@export var ui_audio_start : bool = false
#@export var ui_audio_timer : bool = false
#@export var ui_audio_end : bool = false
#
#@export var ui_audio_crossroad_2 : bool = false
#@export var ui_audio_crossroad_4 : bool = false
#@export var ui_audio_crossroad_6 : bool = false
#
#@export var ui_audio_setting_loop : bool = false
#@export var ui_audio_to_tool : bool = false
#
#@export_group("Unic Ar")
#@export var ui_link_data_ar : Array[PathNode]
