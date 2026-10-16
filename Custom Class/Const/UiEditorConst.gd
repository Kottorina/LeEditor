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

enum EnumAddNodeCategory {
Tool,Dialogue,Audio
}
const UiAddNodeCategory : Dictionary = {
EnumAddNodeCategory.Tool : "Tool:",
EnumAddNodeCategory.Dialogue : "Dialogue",
EnumAddNodeCategory.Audio : "Audio",
}

# /

enum EnumGraphNodeMain {

}
const UiGraphNodeMain : Dictionary = {
	
}

# /

enum EnumGraphNodeLayer {

}
const UiGraphNodeLayer : Dictionary = {
	
}

# /

## // 

const Del : String = "Del"
const Copy : String = "Copy"
