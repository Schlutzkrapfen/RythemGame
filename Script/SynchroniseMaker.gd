extends Control
@export var timer:Timer


var offsetArray:Array[float]

func _input(event):
	if event.is_action_pressed("Controller_Input"):
		offsetArray.append(1.0 -timer.time_left)
		if offsetArray.size() == 10:
			offsetArray.sort()
			print("YOUR SYNcronosiation is "+ str(offsetArray[3]))
			print(offsetArray)
		
	

func _on_rhythm_notifier_beat(current_beat):
	timer.wait_time = 1.0
	timer.start()
