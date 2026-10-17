extends Resource
class_name UiEditorConst

const Empty : String = "Is Empty"

const Save : String = "Save"
const Open : String = "Open"
const File : String = "File"

const CurentLayer : String = "Layer: " 

const CurrentScene : String = "Scene: "
const AddSceneBut : String = "Add New Scene"
const DelSceneBut : String = "Del Scene"
const RenameSceneBut : String = "Rename Scene"

## //
const AddNode : String = "AddNode:"

# /

# Категория Нода В Ui
enum EnumAddNodeCategory {
Tool,Dialogue,Audio
}
const UiAddNodeCategory : Dictionary = {
EnumAddNodeCategory.Tool : "Tool:",
EnumAddNodeCategory.Dialogue : "Dialogue",
EnumAddNodeCategory.Audio : "Audio",
}

# Заголовок Нода Графа
enum EnumGraphNodeMain {
StartBake, StartBakeEmpty
}
const UiGraphNodeMain : Dictionary = {
EnumGraphNodeMain.StartBake : "Start Bake",
EnumGraphNodeMain.StartBakeEmpty : "Start Empty Bake",
}

# Заголовок Слоя В Ноде Графа
enum EnumGraphNodeLayer {
ToolConnector,AudioConnector,DialogueConnector
}
const UiGraphNodeLayer : Dictionary = {
EnumGraphNodeLayer.ToolConnector : "Tool Connector",
EnumGraphNodeLayer.AudioConnector : "Audio Connector",
EnumGraphNodeLayer.DialogueConnector : "Dialogue Connector",
}


## // 

const Del : String = "Del"
const Copy : String = "Copy"
