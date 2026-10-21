extends Node
class_name EditorSystem

var free_id : int = 0
func GetFreeId() -> int:
	free_id += 1
	return free_id
const NullId = -1
