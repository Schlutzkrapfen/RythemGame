extends Control

@export var progress:ProgressBar

func _on_midi_player_midi_event(_channel, _event):
	$AnimationPlayer.play("Tick")

func _process(_delta):
	pass
	#progress.value = $"../Timer".time_left
