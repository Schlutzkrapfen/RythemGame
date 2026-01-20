extends HBoxContainer

@export var slider:HSlider
@export var edit:LineEdit

func _ready():
	slider.value = GlobalSettings.MasterSound
	edit.text = str(int(GlobalSettings.MasterSound*100))
func _on_h_slider_value_changed(value):
	GlobalSettings.MasterChanged(value)
	edit.text = str(int(value*100))


func _on_line_edit_text_submitted(new_text):
	var value:float = (float(new_text)/100)
	GlobalSettings.MasterChanged(value)
	slider.value = value
