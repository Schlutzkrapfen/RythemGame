extends Button

func _input(event):
	if event.is_action_pressed("NextLevel"):
		if get_parent().visible && !self.disabled:
			NextLevel()

func NextLevel():
	if Global.level_registery[Global.currentLevel].PossibleHouseUnlocks != null:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/UnlockScreen.tscn")
	else:
		Global.currentLevel +=1;
		get_tree().paused = false
		get_tree().change_scene_to_file(Global.level_registery[Global.currentLevel].levelPath)


func _ready():
	if Global.currentLevelStatus == Global.LevelStatus.Lost ||  Global.currentLevelStatus == Global.LevelStatus.LostTime:
		self.disabled = true
func _on_button_up():
	NextLevel()
