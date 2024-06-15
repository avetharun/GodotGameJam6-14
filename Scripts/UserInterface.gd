class_name UserInterface extends Control

static var INSTANCE : UserInterface

# TODO! @Ares todo: make these fetch from OnReady if possible


@export var MainMenuRelatedUI : Array[Control]
@export var InGamePauseMenuRelatedUI : Array[Control]


func _ready():
	INSTANCE = self

func SetIsPlayingGame(state : bool):
	GameConstants.Instance.IsPlayingGame = state

func _process(_delta):
	for pause_control in InGamePauseMenuRelatedUI: pause_control.set_visible(GameConstants.Instance.IsPlayingGame);
	for main_menu_control in MainMenuRelatedUI: main_menu_control.set_visible(!GameConstants.Instance.IsPlayingGame);

func go_to_menu():
	pass
