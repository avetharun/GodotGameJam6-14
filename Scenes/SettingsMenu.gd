class_name SettingsMenu extends Panel

@onready var baseSettings : SettingsBase

@export var SettingsLabels : Array[SettingsLabel]
@export var RootSettingsContainer : BoxContainer

func AddSettingsObject(value : SettingsValue):
	if (value.State == "Hidden"): # ! If we want to hide settings, we can. IE for WIP things like controls!
		return
	var AddedIndex = -1;
	value.HiddenName = value.Name # ! COPY NEEDED!!!
	for label in SettingsLabels: # * We don't actually want to modify the base settings object!!!
		if (value.HiddenName.begins_with(label.LabelKey) || value.HiddenName.substr(1).begins_with(label.LabelKey)):
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

func Save():
	if (!shouldSaveSettings): return
	var config = ConfigFile.new()
	for kv in baseSettings.Settings:
		kv.ToIniFile(config)
	print(config.encode_to_text())
	config.save("user://settings.ini")
var shouldSaveSettings:bool = true
func ResetSettings():
	baseSettings.Settings.clear()
	shouldSaveSettings = false
	DirAccess.remove_absolute("user://settings.ini") #! Will take effect upon restart!
func Load():
	if (FileAccess.file_exists("user://settings.ini")):
		# * Load settings from previous session if it exists (HTML5 incompatible???? idk we'll see! :D )
		print("Found existing file!")
		var config = ConfigFile.new()
		config.load("user://settings.ini")
		print(config.encode_to_text())
		baseSettings = SettingsBase.new()
		baseSettings.Settings = SettingsValue.FromIniFile(config)
	else: baseSettings = load("res://SettingsBase_Resource.tres")
	for settings_value in baseSettings.Settings:
		AddSettingsObject(settings_value);
	pass
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save()
