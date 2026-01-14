extends Node




func _on_button_down() -> void:
	Global.ResetLevel()
	get_tree().change_scene_to_file(Global.level_registery[Global.currentLevel].levelPath)
