extends Node


@export var SceneToLoad : PackedScene
@export var SceneName: String

func Unload():

func Load():
    var newScene = SceneToLoad.instantiate()
    newScene.set_meta("SCN_NAME", SceneName) 
    GameConstants.Instance.add_sibling(newScene)