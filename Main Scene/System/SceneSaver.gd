extends Node
class_name SceneSaver

@export_group("Managers")

@export var graph_manager : GraphManager

func GetActualScene() -> LeSceneFile:
	var scene := LeSceneFile.new() 
	
	scene.ui_scene = graph_manager.GetSceneUi()
	
	return scene
