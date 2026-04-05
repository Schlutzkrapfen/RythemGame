extends Control

@export var controll:Control
var endBeat:int = 6
var startScale:float = 2


func SpawnThePoints():
	var top = Vector2(self.size.x-controll.size.x,0)
	var tween = get_tree().create_tween()
	#controll.size = Vector2 (self.size.x,controll.size.y)
	controll.position = top
	controll.scale = Vector2(1,1)
	controll.modulate = Color(1,1,1,0)
	tween.tween_property(controll,"modulate", Color.WHITE,1)
	
	
	

func _on_rhythm_notifier_beat(current_beat):
	if current_beat == endBeat:
		var tween1 = get_tree().create_tween()
		tween1.tween_callback(SpawnThePoints)
	if startScale == 1:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(controll,"scale", Vector2(1.1*startScale,1.1*startScale),0.1)
	tween.tween_property(controll,"scale", Vector2(1*startScale,1*startScale),0.05)
	if current_beat == endBeat -1:
		tween.tween_property(controll,"scale", Vector2(0,0),0.1)
		startScale = 1
	#tween.tween_callback(controll.queue_free)
