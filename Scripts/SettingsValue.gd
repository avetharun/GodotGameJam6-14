class_name SettingsValue extends Resource

@export_enum("Slider", "Keybind", "Enum", "String", "Switch", "Box", "Bool") var Type : String
@export_enum("Hidden", "Visible") var State : String = "Visible"
@export var DefaultValue : String
@export var Name : String
var HiddenName : String



func ToIniFile(file:ConfigFile):
	var mName = HiddenName.replace(" ", "_")
	var val1 = DefaultValue
	if (holder is KeyInputButton): val1 =  OS.get_keycode_string((holder as KeyInputButton).RequestedKey)
	elif (holder is HSlider): val1 = (holder as HSlider).value
	elif (holder is CheckButton or holder is CheckBox): val1 = (holder as BaseButton).button_pressed
	file.set_value(mName,  "Value", val1)
	file.set_value(mName,  "Type", Type)
	file.set_value(mName,  "State", State)
	return

static func FromIniFile(file:ConfigFile) -> Array[SettingsValue]:
	var arr : Array[SettingsValue] = []
	for kName in file.get_sections():
		var kv = SettingsValue.new()
		kv.Name = kName.replace("_", " ");
		var val1 = file.get_value(kName, "Value");
		if (val1 is float): val1 = String.num(val1)
		if (val1 is int): val1 = String.num_int64(val1)
		if (val1 is bool): val1 = ("true" if val1 else "false")
		kv.DefaultValue = val1
		kv.Type = file.get_value(kName, "Type")
		kv.State = file.get_value(kName, "State")
		arr.append(kv)
	return arr
var holder : Control
# INTERNAL: Generates the required input node for the type of settings 
func _GenerateInputPart():
	match StringName(Type):
		&"Slider":
			var slider = HSlider.new();
			slider.min_value = 0;
			slider.max_value = 1;
			slider.custom_minimum_size.x = 200
			slider.step = 0.005
			slider.value = DefaultValue.to_float()
			holder = slider
			return slider;
		&"Switch":
			var state = CheckButton.new();
			state.button_pressed = DefaultValue.to_lower().substr(0,4) == "true";
			holder = state
			return state
		&"Bool", &"Box":
			var state = CheckBox.new();
			state.button_pressed = DefaultValue.to_lower().substr(0,4) == "true";
			holder = state
			return state
		&"Keybind":
			var kib : KeyInputButton = KeyInputButton.new()
			kib.RequestedKey = OS.find_keycode_from_string(DefaultValue)
			holder = kib
			return kib
	var unknownType = Label.new()
	unknownType.text = "[⚠️]Unknown settings type " + Type + "!"
	return unknownType

# Creates (but doesn't spawn) a node tree that represents the settings value
func GenerateSettingsTable():
	var container_root = GridContainer.new();
	container_root.columns = 2
	container_root.custom_minimum_size.x = 1000
	container_root.custom_minimum_size.y = 35
	var label1 = Label.new()
	label1.text = Name
	label1.add_theme_font_override("font", UserInterface.INSTANCE.MainTextFont)
	label1.add_theme_font_size_override("font_size", 38)
	label1.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	label1.custom_minimum_size.x = 400
	container_root.add_child(label1);
	var inputpart = _GenerateInputPart();
	inputpart.scale = Vector2(4, 4)
	container_root.add_child(inputpart)
	return container_root;
