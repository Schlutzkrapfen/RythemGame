extends Node
@export var timer:Timer
@export var rhytm:RhythmNotifier

func _on_main_screen_popups_intro_finished():
	rhytm.running = true
	timer.start()
