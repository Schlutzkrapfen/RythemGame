extends Node
@export var UnlockScreenPath:String
@export var timer:Timer
@export var rythms:Array[RhythmNotifier]
var timeWaitUntilSwitch:float = 0.3
var simultaneous_scene:Node = preload("res://Scenes/winscreen.tscn").instantiate()
signal finished


func _on_timer_timeout():
	await get_tree().create_timer(timeWaitUntilSwitch).timeout
	emit_signal("finished")
	timer.stop()
	for rythm in rythms:
		rythm.running = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.currentLevelStatus = Global.LevelStatus.LostTime
	get_parent().add_child(simultaneous_scene)


func _on_level_misson_missions_made():
	await get_tree().create_timer(timeWaitUntilSwitch).timeout
	emit_signal("finished")
	for rythm in rythms:
		rythm.running = false
	timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.currentLevelStatus = Global.LevelStatus.Win
	Global.pointsDict[Global.Points.time] = int(timer.time_left *100)
	get_parent().add_child(simultaneous_scene)
	
