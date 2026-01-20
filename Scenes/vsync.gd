extends HBoxContainer
@export var checkbox:CheckBox 

func  _ready():
	checkbox.button_pressed = GlobalSettings.vsynch
