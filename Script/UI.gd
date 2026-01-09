extends Control

@export var progress:ProgressBar
@onready var timer:Timer = $"../Timer"


func _ready():
	progress.max_value = Global.level_registery[Global.currentLevel].MaxTime
	progress.value = progress.max_value
func _process(_delta):
	if timer != null:
		if !timer.is_stopped():
			progress.value = timer.time_left
	pass


func _on_rhythm_notifier_beat(_current_beat):
	$AnimationPlayer.play("Tick")
