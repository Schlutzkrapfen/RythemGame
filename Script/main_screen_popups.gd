extends Control
enum  ImagesEnum  {Three = 0, Two=1, One =2, Go = 3, Mouse=4,MousePressed=5} 

@export var Images: Array[Texture2D]
@onready var textureRect:TextureRect = $TextureRect
var timesinslastInput:float = 0
@export var timeUntilTipGetsShown:float = 5
var loop:int = 0
signal IntroFinished

func _input(event) -> void:
	# Check specifically for a left mouse button press
	if event.is_action_pressed("Controller_Input"):
		timesinslastInput = 0
	
	#if event.is_action_pressed("Controller_Down")||event.is_action("Controller_Left")||event.is_action("Controller_Right")||event.is_action("Controller_Up"):
	#	timesinslastInput = 0
func _on_rhythm_notifier_beat(current_beat):
	if current_beat < 4:
		textureRect.texture = Images[current_beat]
	elif current_beat == 4:
		emit_signal("IntroFinished")
	if current_beat == 5:
		textureRect.visible = false
		
func _process(delta):
	timesinslastInput += delta
	if timesinslastInput > timeUntilTipGetsShown && !textureRect.visible :
		textureRect.visible = true
		animation()
		textureRect.modulate = Color(1.0, 1.0, 1.0, 0.443)
		

func animation():
	loop += 1
	if loop %2 == 0:
		textureRect.visible=false
		textureRect.texture =Images[ImagesEnum.Mouse]
	else:
		textureRect.texture =Images[ImagesEnum.MousePressed]
	await get_tree().create_timer(0.2).timeout
	if timesinslastInput > timeUntilTipGetsShown:
		animation()
	else:
		textureRect.visible=false
	
	
