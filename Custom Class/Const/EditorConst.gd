extends Resource
class_name EditorConst

const f_set_setting_value : String = "SetSettingValue"
const f_get_setting_value : String = "GetSettingValue"

const v_setting_is_auto_export : String = "is_auto_export"

const StartBake : String = "StartBake"
const GetSaveContainer : String = "GetSaveContainer"

enum DataKey {
Nothing,
FirstData,
SecondData,
ThirdData,
FourthData,
FifthData,
SixthData,
SeventhData, 
EighthData,
NinthData,
TenthData,
}

# Заголовок Нода Графа
enum GraphNodeType {

Empty, # Служебные, для отстувия нода при загрузке

StartBakeEmpty,

DialogueStart,
DialogueLine,
DialogueChoise2,
DialogueChoise3,
DialogueChoise4,
DialogueChoise5,
DialogueSetting,
DialogueToTool,
}

enum ConnectorType {
Tool,Dialogue,Audio 
}
const ConnectorColor : Dictionary = {
ConnectorType.Tool : Color.WHITE,
ConnectorType.Audio : Color.AQUA,
ConnectorType.Dialogue : Color.RED,
}
const ConnectorValue : Dictionary = {
ConnectorType.Tool : 1,
ConnectorType.Audio : 2,
ConnectorType.Dialogue : 3,
}

enum BodyNode {
Label_,SpinBox_,TextEdit_,CheckBox_
}

#enum GraphNodeType {
#MAKE_ROOM, ENTER_LOCATION,
#
#CON_PL,RND_FORK,ROOL_RND_FORK_SET,ROOL_RND_DECO_TILE,MAKE_LOCATION,
#
#START_GENER,TOOL_CROSSROAD,
#
#DIALOGUE_START, DIALOGUE_NODE,END_DIALOGUE,DIALOGUE_CHOISE,DIALOGUE_CON,
#DIALOGUE_SETTING,DIALOGUE_EMIT_SIGNAL,DIALOGUE_AWAIT_SIGNAL,NEXT_DIALOGUE,
#DILOGUE_TO_TOOl
#
#,MAKE_AUDIO,START_AUDIO,AUDIO_TIMER,AUDIO_END,AUDIO_CROSSROAD,AUDIO_SETTING_LOOP,
#AUDIO_TO_TOOL
#}
