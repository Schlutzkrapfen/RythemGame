extends Node
@export var UnlockScreenPath:String
@export var timer:Timer
var simultaneous_scene:PackedScene = preload("res://Scenes/winscreen.tscn")
signal finished


func _on_timer_timeout():
	print("LevelLost")
	emit_signal("finished")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.currentLevelStatus = Global.LevelStatus.LostTime
	get_tree().change_scene_to_packed(simultaneous_scene)


func _on_level_misson_missions_made():
	emit_signal("finished")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.currentLevelStatus = Global.LevelStatus.Win
	Global.pointsDict[Global.Points.time] = int(timer.time_left *100)
	get_tree().change_scene_to_packed(simultaneous_scene)
	
