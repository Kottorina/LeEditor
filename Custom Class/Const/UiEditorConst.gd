extends EditorConst
class_name UiEditorConst

# /
const Empty : String = "Is Empty"

const AutoExport : String = "Is Auto Export"
const Save : String = "Save"
const Open : String = "Open"
const File : String = "File"
const Export : String = "Export"

const CurentLayer : String = "Layer: " 

const CurrentScene : String = "Scene: "
const AddSceneBut : String = "Add New Scene"
const DelSceneBut : String = "Del Scene"
const RenameSceneBut : String = "Rename Scene"

## //
const AddNode : String = "AddNode:"
const CopyNode : String = "CopyNode"
const DelNode : String = "DelNode"

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

# Title Самого EditorGraphNode
const UiGraphNodeMainTitle : Dictionary = {
GraphNodeType.Empty : "Empty!",

GraphNodeType.Direction : "Direction",

GraphNodeType.StartBakeEmpty : "Start Empty Bake",

GraphNodeType.DialogueStart : "Dialogue Start",
GraphNodeType.DialogueLine : "Dialogue Line",
GraphNodeType.DialogueChoise2 : "Dialogue Choise 2" ,
GraphNodeType.DialogueChoise3 : "Dialogue Choise 3" ,
GraphNodeType.DialogueChoise4 : "Dialogue Choise 4" ,
GraphNodeType.DialogueChoise5 : "Dialogue Choise 5" ,
GraphNodeType.DialogueSetting : "Dialogue Setting" ,
GraphNodeType.DialogueToTool : "Dialogue To Tool" ,

GraphNodeType.MakeMetadataLink : "Make Metadata Link For:",

}

# Title Слоя EditorGraphNode
enum EnumGraphNodeLayer {
ToolConnector,AudioConnector,DialogueConnector,

DialogueDirection,
DialogueCharacter, DialogueLine, DialogueChoiseLine
}
const UiGraphNodeLayer : Dictionary = {
EnumGraphNodeLayer.ToolConnector : "Tool Connector",

EnumGraphNodeLayer.AudioConnector : "Audio Connector",
EnumGraphNodeLayer.DialogueConnector : "Dialogue Connector",

EnumGraphNodeLayer.DialogueDirection : "",
EnumGraphNodeLayer.DialogueCharacter : "Dialogue Character",
EnumGraphNodeLayer.DialogueLine : "Dialogue Line",
EnumGraphNodeLayer.DialogueChoiseLine : "Dialogue Choise Line",
}

enum EnumPresetData {
Nothing,
Direction,
}
const UiSplitChar : String = "/" ## "/" Разделители Для OptionButton
const UiPresetData : Dictionary = {
EnumPresetData.Direction : (  "<-- Omnidir -->" + UiSplitChar + "--> Right -->" + UiSplitChar + "<-- Left <--" ),
}
## // 

const Del : String = "Del"
const Copy : String = "Copy"
