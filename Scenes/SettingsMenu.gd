class_name SettingsMenu extends Panel

@onready var baseSettings : SettingsBase = load("res://SettingsBase_Resource.tres")

@export var SettingsLabels : Array[SettingsLabel]
@export var RootSettingsContainer : BoxContainer

func AddSettingsObject(value : SettingsValue):
	if (value.Name.begins_with("HIDDEN") || value.Name.substr(1).begins_with("HIDDEN")): # ! If we want to hide settings, we can. IE for WIP things like controls!
		return
	var AddedIndex = -1;
	for label in SettingsLabels.duplicate(): # * We don't actually want to modify the base settings object!!!
		if (value.Name.begins_with(label.LabelKey) || value.Name.substr(1).begins_with(label.LabelKey)):
			value.Name = value.Name.replace(label.LabelKey +".", "");
			value.Name = value.Name.replace(label.LabelKey +"_", "");
			value.Name = value.Name.replace(label.LabelKey +"-", "");
			value.Name = value.Name.replace("[" +label.LabelKey +"]", "");
			value.Name.dedent();
			label.add_sibling(value.GenerateSettingsTable())
			return
	var settingsValueSpawner = value.GenerateSettingsTable();
	RootSettingsContainer.add_child(settingsValueSpawner);
	RootSettingsContainer.move_child(settingsValueSpawner, AddedIndex);
	return
func _ready():
	if (ResourceLoader.exists("user://game/Settings.tres")):
		# * Load settings from previous session if it exists (HTML5 incompatible???? idk we'll see! :D )
		baseSettings = ResourceLoader.load("user://game/Settings.tres");
	for settings_value in baseSettings.Settings:
	
		AddSettingsObject(settings_value);
	pass
func free():
	ResourceSaver.save(baseSettings, "user://game/Settings.tres")
