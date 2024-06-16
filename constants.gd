class_name GameConstants extends Node

var ui_src : UserInterface
static var Instance : GameConstants
var IsPlayingGame : bool = false


func _ready():
	Instance = self
	var ui_scn_obj = (load("res://Scenes/UserInterface.tscn") as PackedScene).instantiate()
	var ui_scn := ui_scn_obj as UserInterface # ! WHAT THE FRESH FUCK IS THIS?????
	ui_src = ui_scn
	add_child(ui_scn)