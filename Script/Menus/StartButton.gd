extends Button

func _input(event):
	if event.is_action_pressed("NextLevel"):
		if get_parent().visible &&self.visible:
			StartLevelLevel()


func StartLevelLevel():
	if Global.currentLevel == 0:
		get_tree().change_scene_to_file("res://Scenes/UnlockScreen.tscn")
		return
	Global.ResetLevel()
	get_tree().change_scene_to_file(Global.level_registery[Global.currentLevel].levelPath)

func _on_button_down() -> void:
	StartLevelLevel()
