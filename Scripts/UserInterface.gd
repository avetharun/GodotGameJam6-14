class_name UserInterface extends Control

static var INSTANCE : UserInterface

# TODO! @Ares todo: make these fetch from OnReady if possible


@export var MainMenuRelatedUI : Array[Control]
@export var InGamePauseMenuRelatedUI : Array[Control]
@export var SettingsMenuScreen : SettingsMenu
@export var MainTextFont : Font

func _ready():
	INSTANCE = self
	SettingsMenuScreen.Load()

func SetIsPlayingGame(state : bool):
	GameConstants.Instance.IsPlayingGame = state

func _process(_delta):
	for pause_control in InGamePauseMenuRelatedUI: pause_control.set_visible(GameConstants.Instance.IsPlayingGame);
	for main_menu_control in MainMenuRelatedUI: main_menu_control.set_visible(!GameConstants.Instance.IsPlayingGame);

func go_to_menu():
	pass



func ExitGame(): 
	if (!is_inside_tree()): return
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		var file = FileAccess.open("user://README.txt", FileAccess.WRITE)
		file.store_line("Thank you for playing our game! We hope you enjoyed it!")
		file.store_line("Developers:")
		file.store_line("- Feintha")
		file.store_line("- AresRF")
		file.store_line("Artists:")
		file.store_line("- TBD (Probably not fei lol)")
		file.store_line("Storywriters:")
		file.store_line("- AresRF")
		file.store_line("- Feintha")
		file.store_line("- Ice909")