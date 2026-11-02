extends Resource
class_name ExportFunc

func FromMetadataToInstructionKey( layer : String, object_id : int, link_name : String ) -> String:
	var instruction_key : String = str(
		layer, UiEditorConst.UiSplitChar,
		object_id, UiEditorConst.UiSplitChar,
		link_name
		)
	
	return instruction_key
