extends Node

func _input(event):
	if event.is_action_pressed("Quit"):
		if get_parent().visible &&self.visible:
			_on_button_down()

func _on_button_down() -> void:
	get_tree().quit()
