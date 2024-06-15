class_name KeyInputButton extends Button

func setCapturing():
    capturing = true
func setStopCapturing():
    capturing = false
    release_focus()

func _ready():
    connect("pressed", setCapturing)
    connect("focus_exited", setStopCapturing)

func _process(delta):
    if (!is_visible_in_tree()):
        capturing = false
        return;
    if (capturing):
        text = "Press a key"
    else:
        text = OS.get_keycode_string(RequestedKey)
var capturing : bool = false

var RequestedKey : Key = KEY_0


func _gui_input(event):
    if (capturing && event is InputEventKey && event.pressed):
        var iek : InputEventKey = event
        if (iek.keycode == KEY_ESCAPE): # ! Cancel
            capturing = false
            return;
        RequestedKey = iek.keycode
        text = iek.as_text_key_label()
        capturing = false
        
        release_focus()
    pass
