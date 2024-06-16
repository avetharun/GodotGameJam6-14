class_name Keybinding extends Resource
@export var Name : String

func GetKey():
    return UserInterface.INSTANCE.SettingsMenuScreen.baseSettings.GetSettingsValueFor(Name)

