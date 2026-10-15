extends Node
class_name SceneLoader

@export_group("Managers")

@export var graph_manager : GraphManager

func LoadScene( scene : LeSceneFile ) -> void:
	print("_Load Scene: ",scene.scene_name)
	
	graph_manager.SetSceneUi(scene.ui_scene)
