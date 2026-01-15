extends Node




func _on_button_down() -> void:
	if Global.currentLevel == 0:
		get_tree().change_scene_to_file("res://Scenes/UnlockScreen.tscn")
		return
	Global.ResetLevel()
	get_tree().change_scene_to_file(Global.level_registery[Global.currentLevel].levelPath)
