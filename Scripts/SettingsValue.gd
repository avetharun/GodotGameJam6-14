class_name SettingsValue extends Resource

@export_enum("Slider Zero to One", "Keybind") var Type : String
@export var DefaultValue : String
@export var Name : String
# INTERNAL: Generates the required input node for the type of settings 
func _GenerateInputPart():
    match Type:
        "Slider Zero to One":
            var slider = HSlider.new();
            slider.min_value = 0;
            slider.max_value = 1;
            slider.custom_minimum_size.x = 200
            slider.step = 0.005
            slider.value = DefaultValue.to_float()
            return slider;
        "Keybind":
            var kib : KeyInputButton = KeyInputButton.new()
            kib.RequestedKey = OS.find_keycode_from_string(DefaultValue)
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
    print(label1)
    print(container_root)
    label1.text = Name
    label1.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
    label1.custom_minimum_size.x = 400
    container_root.add_child(label1);
    var inputpart = _GenerateInputPart();
    inputpart.scale = Vector2(4, 4)
    container_root.add_child(inputpart)
    return container_root;