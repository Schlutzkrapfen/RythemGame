extends Node




func _on_button_down() -> void:
	Global.currentResources = {
	Global.Points.unemployed:0,
	Global.Points.multiplaier:1,
	Global.Points.unusedWood:0}
	
	get_tree().change_scene_to_file(Global.level_registery[Global.currentLevel].levelPath)
	pass # Replace with function body.
