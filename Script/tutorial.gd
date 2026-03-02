extends Node
@export var timer:Timer
@export var rhytm:RhythmNotifier
##Should be half of the amount how much you have to hit the notes
var offset:float = Global.musicOffset
	
func _on_main_screen_popups_intro_finished():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	rhytm.running = true
	timer.start()
	#$"../AudioControl/Music".play()
