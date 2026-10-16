extends Resource
class_name EditorConst

const StartBake : String = "StartBake"
const GetSaveContainer : String = "GetSaveContainer"

enum DataKey {
FirstData,
SecondData,
ThirdData,
FourthData,
FifthData,
}

enum GraphNodeType {
MAKE_ROOM, ENTER_LOCATION,

CON_PL,RND_FORK,ROOL_RND_FORK_SET,ROOL_RND_DECO_TILE,MAKE_LOCATION,

START_GENER,TOOL_CROSSROAD,

START_DIALOGUE,DIALOGUE_NODE,END_DIALOGUE,DIALOGUE_CHOISE,DIALOGUE_CON,
DIALOGUE_SETTING,DIALOGUE_EMIT_SIGNAL,DIALOGUE_AWAIT_SIGNAL,NEXT_DIALOGUE,
DILOGUE_TO_TOOl

,MAKE_AUDIO,START_AUDIO,AUDIO_TIMER,AUDIO_END,AUDIO_CROSSROAD,AUDIO_SETTING_LOOP,
AUDIO_TO_TOOL
}

enum ConnectorType {
Tool,Dialogue,Audio 
}
const ConnectorColor : Dictionary = {
ConnectorType.Tool : Color.WHITE,
ConnectorType.Audio : Color.AQUA,
ConnectorType.Dialogue : Color.RED,
}

enum BodyNode {
Label_,SpinBox_,TextEdit_,CheckBox_
}
