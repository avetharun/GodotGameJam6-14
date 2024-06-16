class_name SettingsMenu extends Panel

@onready var baseSettings : SettingsBase

@export var SettingsLabels : Array[SettingsLabel]
@export var RootSettingsContainer : BoxContainer

func AddSettingsObject(value : SettingsValue):
	if (value.State == "Hidden"): # ! If we want to hide settings, we can. IE for WIP things like controls!
		return
	
	var AddedIndex = -1;
	value.HiddenName = value.Name # ! COPY NEEDED!!!
	var regex = RegEx.new()
	# * Replace anything in between %{ and }% (ie "%{some_text}%" would be replaced to "")
	regex.compile("\\%\\{([^\\)]+)\\}\\%")
	for label in SettingsLabels: # * We don't actually want to modify the base settings object!!!
		if (value.HiddenName.begins_with(label.LabelKey) || value.HiddenName.substr(1).begins_with(label.LabelKey)):
			print(value.HiddenName)
			value.Name = value.Name.replace(label.LabelKey +".", "");
			value.Name = value.Name.replace(label.LabelKey +"_", "");
			value.Name = value.Name.replace(label.LabelKey +"-", "");
			value.Name = value.Name.replace("[" +label.LabelKey +"]", "");
			value.Name = value.Name.replace("(" +label.LabelKey +")", "");
			value.Name = regex.sub(value.Name, "")
			value.Name.dedent();
			AddedIndex = label.get_index() + 1
			# label.add_sibling(value.GenerateSettingsTable())
			# return
	var settingsValueSpawner = value.GenerateSettingsTable();
	RootSettingsContainer.add_child(settingsValueSpawner);
	RootSettingsContainer.move_child(settingsValueSpawner, AddedIndex);
	return
func Save():
	if (!shouldSaveSettings): return
	var config = ConfigFile.new()
	for kv in baseSettings.Settings:
		kv.ToIniFile(config)
	config.save("user://settings.ini")
var shouldSaveSettings:bool = true
func ResetSettings():
	for child in RootSettingsContainer.get_children():
		if (child is SettingsLabel):
			continue;
		RootSettingsContainer.remove_child(child)
		child.queue_free()
	baseSettings.Settings.clear()
	call_deferred("Resave")

func Resave():
		baseSettings = ResourceLoader.load("res://SettingsBase_Resource.tres", "", ResourceLoader.CACHE_MODE_IGNORE)
		for settings_value in baseSettings.Settings:
			AddSettingsObject(settings_value);
		Save()

func Load():
	var st1 = load("res://SettingsBase_Resource.tres")
	if (FileAccess.file_exists("user://settings.ini")):
		# * Load settings from previous session if it exists (HTML5 incompatible???? idk we'll see! :D )
		print("Found existing file!")
		var config = ConfigFile.new()
		config.load("user://settings.ini")
		var cfgParsed = SettingsValue.FromIniFile(config)
		
		if (st1.Settings.size() != cfgParsed.size()):
			# ! We need to update the user's settings with the new values (ie, if we add a new setting, automatically add it to the file & menu)
			for key in st1.Settings:
				var found = false
				for keySaved in cfgParsed:
					if (key.Name == keySaved.Name): found = true; break;
				if (!found):
					cfgParsed.append(key)
			pass
		baseSettings = SettingsBase.new()
		baseSettings.Settings = cfgParsed
	else: baseSettings = st1
	for settings_value in baseSettings.Settings:
		AddSettingsObject(settings_value);
	pass
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Save()
