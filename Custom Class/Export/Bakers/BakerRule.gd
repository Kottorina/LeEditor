extends Resource
class_name BakerRule

@export var start_node_preset : GraphNodeMainInstr
func GetStartInstructionKey() -> String:
	if start_node_preset:
		return start_node_preset.resource_path.get_file().get_basename()
	push_error("start_node_preset Is Null")
	return UiEditorConst.Empty

#var ui_const_func := UiConstFunc.new()
#var path_node_const := PathNodeConst.new()

#const ROOMNODENAME = "Room Node: "
#const ROOMS_UI_LOCATIONS : String = "Locations"
#
#func BakeUi(objects_ar : Array, category : String) -> Array:
	#
	#var callable = Callable(self, "FromObjectToBigInstr")
	#if not callable.is_valid():
		#return []
	#
	#var big_instr_ar : Array[BigGraphNodeMakeInsts]
	#
	#for obj in objects_ar:
		#var big_instr : Array[BigGraphNodeMakeInsts] = callable.call(obj, category)
		#big_instr_ar.append_array(big_instr)
	#
	#return big_instr_ar
	#
#func BakePathDataPreview(path_data : Variant) -> LeFile:
	#if typeof(path_data) != TYPE_STRING:
		#push_warning("path_data Is Not String")
		#return null
	#var callable = Callable(self, "FromPathDataToPreview")
	#if not callable.is_valid():
		#return null
	#return callable.call(path_data)
#
#func BakePathDataImport(path_data : Variant) -> LeFile:
	#if typeof(path_data) != TYPE_STRING:
		#push_warning("path_data Is Not String")
		#return null
	#var callable = Callable(self, "FromPathDataToImport")
	#if not callable.is_valid():
		#return null
	#return callable.call(path_data)
