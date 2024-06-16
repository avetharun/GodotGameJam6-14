class_name SettingsBase extends Resource

@export var Settings : Array[SettingsValue] = []


# ! Null check required
func GetSettingsValueFor(name: String):
	for val in Settings:
		if (val.HiddenName.contains(name)):
			return val.GetValue()
	return null
