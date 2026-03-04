extends Control
enum  ImagesEnum  {Three = 0, Two=1, One =2, Go = 3, Mouse=4,MousePressed=5} 

@export var Images: Array[Texture2D]
@onready var textureRect:TextureRect = $TextureRect
var timesinslastInput:float = 0
@export var timeUntilTipGetsShown:float = 5
var loop:int = 0
var offset:float = Global.musicOffset
var finished:bool = false

signal IntroFinished

func _input(event) -> void:
	if event.is_action_pressed("Controller_Input"):
		timesinslastInput = 0
	
#ATTION this Rythem Spawner is faster because it needs to be as fast that 
#the rythem can be coupled
func _on_rhythm_notifier_beat(current_beat):
	if current_beat < 8:
		textureRect.texture = Images[current_beat/2] 
	elif current_beat == 8:
		emit_signal("IntroFinished")
	if current_beat == 9:
		textureRect.visible = false
		

func _process(delta):
	if finished:
		return
	timesinslastInput += delta
	if timesinslastInput > timeUntilTipGetsShown && !textureRect.visible :
		textureRect.visible = true
		animation()
		textureRect.modulate = Color(1.0, 1.0, 1.0, 0.443)
		
func Finished():
	finished =true
	
func animation():
	loop += 1
	if loop %2 == 0:
		textureRect.visible=false
		textureRect.texture =Images[ImagesEnum.Mouse]
	else:
		textureRect.texture =Images[ImagesEnum.MousePressed]
	await get_tree().create_timer(offset).timeout
	if timesinslastInput > timeUntilTipGetsShown:
		animation()
	else:
		textureRect.visible=false
	
	
