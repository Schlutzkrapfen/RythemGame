extends HBoxContainer
@export var checkbox:CheckBox 

func  _ready():
	checkbox.button_pressed = GlobalSettings.automaticSwitcher



func _on_check_box_toggled(toggled_on):
	GlobalSettings.automaticSwitcher = toggled_on
	GlobalSettings.SaveFile()
