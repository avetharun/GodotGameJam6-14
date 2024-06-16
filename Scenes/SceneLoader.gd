class_name SceneLoader extends Node

# * The scene to load. Default for Load()
@export var SceneToLoadPath : StringName
# * The scene name to assign (Or when calling Unload(), the )
@export var SceneName: String

func Unload():
	for child in GameConstants.Instance.get_parent().get_children():
		if (child.has_meta("SCN_NAME") && child.get_meta("SCN_NAME") == SceneName):
			child.queue_free()
func UnloadAllRuntimeScenes():
	for child in GameConstants.Instance.get_parent().get_children():
		if child.has_meta("SCN_LOADED_AT_RUNTIME") && !child.has_meta("SCNMGR_DISABLE_AUTO_UNLOAD"):
			child.queue_free()
func Load():
	LoadFromPath(SceneToLoadPath)
func LoadFromScene(scene:PackedScene):
	var newScene = scene.instantiate()
	newScene.set_meta("SCN_NAME", SceneName) 
	newScene.set_meta("SCN_LOADED_AT_RUNTIME", true) 
	if (!shouldUnload):
		newScene.set_meta("SCNMGR_DISABLE_AUTO_UNLOAD", true)
	GameConstants.Instance.add_sibling(newScene)
func LoadFromPath(path:String):
	var newScene = load(path)
	LoadFromScene(newScene)
@export var shouldUnload : bool = true
# * Bad name: Explanation::
	# * If true, the scene spawned from this object will not be freed from UnloadAllRuntimeScenes. Unload() will still free regardless!
func SetShouldUnload(state:bool):
	shouldUnload = state
