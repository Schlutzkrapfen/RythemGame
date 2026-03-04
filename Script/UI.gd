extends Control

@export var progress:ProgressBar
@onready var timer:Timer = $"../Timer"
@onready var anim:AnimationPlayer = $AnimationPlayer
@onready var pauseMenu:Popup = $CanvasLayer/Control/Popup
@export var rythms:Array[RhythmNotifier]

func _ready():
	progress.max_value = Global.level_registery[Global.currentLevel].MaxTime
	progress.value = progress.max_value
func _process(_delta):
	if timer != null:
		if !timer.is_stopped():
			var tween = get_tree().create_tween()
			tween.tween_property(progress, "self_modulate", Color.RED, timer.wait_time)
			
			if  timer.time_left<progress.max_value/10: 
				
				var tween1 = get_tree().create_tween()
				tween1.tween_property(progress, "scale", Vector2(0.8,0.8), progress.max_value/100)
				tween1.tween_property(progress, "scale", Vector2(1,1), progress.max_value/100)
			
			progress.value = timer.time_left

func _on_rhythm_notifier_beat(_current_beat):
	if anim == null:
		return
	anim.play("Tick")
#Controlls the Pause Menu
func _input(event):
	if event.is_action_pressed("Quit"):
		get_tree().paused = true
		pauseMenu.visible = true
		rythms[0].current_beat = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
