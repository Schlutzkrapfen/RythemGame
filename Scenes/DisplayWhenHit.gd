extends AudioStreamPlayer

var time:float = 0
var deltas:float
var rythemIsActive:float
@export var ryhtm:RhythmNotifier

func _process(delta):
	deltas += delta
	if self.playing:
		time += delta
	if ryhtm == null:
		return
	if ryhtm.running:
		rythemIsActive+= delta
func DisplayTime(_hit:int):
	pass
	#print("Time since Game is playing: " + str(deltas))
	#print("Time since Music is playing: " + str(time))
	#print("Time since rythem is playing: " + str(rythemIsActive))
	#print("Current beathit: " + str(hit))
