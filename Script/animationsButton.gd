extends HBoxContainer
@export var checkbox:CheckBox 

func  _ready():
	checkbox.button_pressed = GlobalSettings.animations


func _on_check_box_toggled(toggled_on):
	GlobalSettings.animations = toggled_on
	GlobalSettings.SaveFile()
