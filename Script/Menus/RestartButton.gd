extends Node


func _input(event):
	if event.is_action_pressed("Restart"):
		if get_parent().visible &&self.visible:
			RestartLevelLevel()


func RestartLevelLevel():
	if Global.currentLevel == 0:
		get_tree().change_scene_to_file("res://Scenes/UnlockScreen.tscn")
		return
	Global.ResetLevel()
	get_tree().change_scene_to_file(Global.level_registery[Global.currentLevel].levelPath)

func _on_button_down() -> void:
	RestartLevelLevel()
