extends Control

@export var progress:ProgressBar


func _process(_delta):
#	progress.value = $"../Timer".time_left
	pass


func _on_rhythm_notifier_beat(_current_beat):
	$AnimationPlayer.play("Tick")
