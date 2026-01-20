extends Node
@export var timer:Timer
@export var rhytm:RhythmNotifier
##Should be half of the amount how much you have to hit the notes
@export var offset:float = 0.1

func _on_main_screen_popups_intro_finished():
	await get_tree().create_timer(rhytm.beat_length -offset).timeout
	rhytm.running = true
	timer.start()
